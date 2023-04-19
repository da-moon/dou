terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = "~> 1.1.9"
}

data "aws_ssm_parameter" "base_ami" { name = "/teamcenter/shared/base_ami/ami_id" }
data "aws_ssm_parameter" "dc_url" { name = "/teamcenter/shared/deployment_center/url" }
data "aws_ssm_parameter" "web_hostname" { name = "/teamcenter/${var.env_name}/web_tier/hostname" }
data "aws_ssm_parameter" "aw_gateway_hostname" { name = "/teamcenter/${var.env_name}/aw_gateway/hostname" }
data "aws_ssm_parameter" "aw_client_builder_hostname" { name = "/teamcenter/${var.env_name}/awc_builder/hostname" }


provider "aws" {
  region = var.region
}

data "aws_s3_object" "core_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/01_core_infra/outputs.json"
}

data "aws_s3_object" "core_env_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/02_core_env/${var.env_name}/outputs.json"
}

data "aws_s3_objects" "maybe_self_outputs" {
  bucket = var.artifacts_bucket_name
  prefix = "stage_outputs/env-${var.env_name}/bake_aw_client_builder/outputs.json"
}

data "aws_s3_object" "self_outputs" {
  count  = length(data.aws_s3_objects.maybe_self_outputs.keys)
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/env-${var.env_name}/bake_aw_client_builder/outputs.json"
}

data "aws_s3_object" "install_scripts" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/03_generate_install_scripts/${var.env_name}/outputs.json"
}

locals {
  changing_rebake_seed  = formatdate("YYYYMMDDhhmmss", timestamp())
  previous_rebake_seed  = length(data.aws_s3_objects.maybe_self_outputs.keys) > 0 ? lookup(jsondecode(data.aws_s3_object.self_outputs[0].body), "rebake_seed", local.changing_rebake_seed) : local.changing_rebake_seed
  rebake_seed           = var.force_rebake ? local.changing_rebake_seed : local.previous_rebake_seed
  packer_dir            = "${path.module}/../../../../components/packer/tc_aw_client_builder"
  common_packer_dir     = "${path.module}/../../../../components/packer/tc_common/centos"
  has_own_machine       = data.aws_ssm_parameter.aw_client_builder_hostname.value != data.aws_ssm_parameter.aw_gateway_hostname.value && data.aws_ssm_parameter.aw_client_builder_hostname.value != data.aws_ssm_parameter.web_hostname.value
}


resource "null_resource" "packer" {
  count = local.has_own_machine ? 1 : 0
  # Rebake only if any of the input variables have changed, or the force_rebake flag is set
  triggers = {
    installation_prefix        = jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix
    vpc_id                     = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id
    subnet_id                  = jsondecode(data.aws_s3_object.core_outputs.body).public_subnet_ids[0]
    webserver_instance_profile = jsondecode(data.aws_s3_object.core_env_outputs.body).instance_profile_id
    region                     = jsondecode(data.aws_s3_object.core_outputs.body).region
    kms_key_id                 = jsondecode(data.aws_s3_object.core_outputs.body).kms_key_id
    base_ami                   = nonsensitive(data.aws_ssm_parameter.base_ami.value)
    tc_efs_id                  = jsondecode(data.aws_s3_object.core_env_outputs.body).tc_efs_id
    install_scripts_path       = jsondecode(data.aws_s3_object.install_scripts.body).scripts_s3_path
    machine_name               = nonsensitive(data.aws_ssm_parameter.aw_client_builder_hostname.value)
    rebake_seed                = local.rebake_seed
    dir_sha1                   = sha1(join("", [for f in fileset(local.packer_dir, "*") : filesha1(format("%s/%s", local.packer_dir, f))]))
    common_dir_sha1            = sha1(join("", [for f in fileset(local.common_packer_dir, "*") : filesha1(format("%s/%s", local.common_packer_dir, f))]))
  }

  provisioner "local-exec" {
    working_dir = local.packer_dir
    environment = {
      AWS_MAX_ATTEMPTS       = 180
      AWS_POLL_DELAY_SECONDS = 30
    }
    command = <<EOF
packer build \
  -var 'installation_prefix=${jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix}' \
  -var 'vpc_id=${jsondecode(data.aws_s3_object.core_outputs.body).vpc_id}' \
  -var 'subnet_id=${jsondecode(data.aws_s3_object.core_outputs.body).public_subnet_ids[0]}' \
  -var 'webserver_instance_profile=${jsondecode(data.aws_s3_object.core_env_outputs.body).instance_profile_id}' \
  -var 'region=${jsondecode(data.aws_s3_object.core_outputs.body).region}' \
  -var 'kms_key_id=${jsondecode(data.aws_s3_object.core_outputs.body).kms_key_id}' \
  -var 'base_ami=${nonsensitive(data.aws_ssm_parameter.base_ami.value)}' \
  -var 'tc_efs_id=${jsondecode(data.aws_s3_object.core_env_outputs.body).tc_efs_id}' \
  -var 'machine_name=${nonsensitive(data.aws_ssm_parameter.aw_client_builder_hostname.value)}' \
  -var 'install_scripts_path=${jsondecode(data.aws_s3_object.install_scripts.body).scripts_s3_path}' \
  -var 'dc_user_secret_name=/teamcenter/shared/deployment_center/username' \
  -var 'dc_pass_secret_name=/teamcenter/shared/deployment_center/password' \
  -var 'dc_url=${nonsensitive(data.aws_ssm_parameter.dc_url.value)}' \
  -var 'ignore_tc_errors=${var.ignore_tc_errors}' \
  -var 'stage_name=bake_aw_client_builder' \
  -var 'build_uuid=${local.rebake_seed}' \
  -debug \
  -machine-readable .

if [ ! $? -eq 0 ]; then
  echo "=== Packer Failed ==="
  exit 1
fi

EOF
  }
}



data "aws_ami" "ami_id" {
  count = local.has_own_machine ? 1 : 0
  depends_on = [
    null_resource.packer
  ]

  most_recent = true
  owners      = ["self"]

  filter {
     name   = "tag:BuildUUID-aw-client"
     values = [local.rebake_seed]
  }
}

resource "aws_s3_object" "outputs" {
  count        = local.has_own_machine ? 1 : 0
  bucket       = var.artifacts_bucket_name
  key          = "stage_outputs/env-${var.env_name}/bake_aw_client_builder/outputs.json"
  content_type = "application/json"
  content      = jsonencode({
    ami_id      = data.aws_ami.ami_id[0].id
    rebake_seed = local.rebake_seed
  })
}
