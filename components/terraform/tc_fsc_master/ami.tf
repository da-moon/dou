
data "aws_ssm_parameter" "base_ami" { name = "/teamcenter/shared/base_ami/ami_id" }
data "aws_ssm_parameter" "dc_url" { name = "/teamcenter/shared/deployment_center/url" }

data "aws_ssm_parameters_by_path" "own_params" { 
  path      = "/teamcenter/${var.env_name}/enterprise_tier/fsc/master" 
  recursive = true
}

data "aws_s3_object" "install_scripts" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/03_generate_install_scripts/${var.env_name}/outputs.json"
}

data "aws_route53_zone" "private" {
  zone_id = jsondecode(data.aws_s3_object.core_outputs.body).private_hosted_zone_id
}

locals {
  changing_rebake_seed        = formatdate("YYYYMMDDhhmmss", timestamp())
  exists_previous_rebake_seed = contains(data.aws_ssm_parameters_by_path.own_params.names, "/teamcenter/${var.env_name}/enterprise_tier/fsc/master/rebake_seed")
  index_previous_rebake_seed  = local.exists_previous_rebake_seed ? index(data.aws_ssm_parameters_by_path.own_params.names, "/teamcenter/${var.env_name}/enterprise_tier/fsc/master/rebake_seed") : -1
  previous_rebake_seed        = local.exists_previous_rebake_seed ? nonsensitive(data.aws_ssm_parameters_by_path.own_params.values[local.index_previous_rebake_seed]) : local.changing_rebake_seed
  rebake_seed                 = var.force_rebake ? local.changing_rebake_seed : local.previous_rebake_seed
  packer_dir                  = "${path.module}/../../packer/tc_enterprise_server"
  common_packer_dir           = "${path.module}/../../packer/tc_common/centos"
  is_start_pool_mgr           = nonsensitive(contains(split(",", data.aws_ssm_parameter.svr_mgr_all.value), data.aws_ssm_parameter.fsc_master_hostname.value))
}


resource "null_resource" "packer" {
  # Rebake only if any of the input variables have changed, or the force_rebake flag is set
  triggers = {
    installation_prefix  = jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix
    vpc_id               = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id
    subnet_id            = jsondecode(data.aws_s3_object.core_outputs.body).public_subnet_ids[0]
    instance_profile     = jsondecode(data.aws_s3_object.core_env_outputs.body).instance_profile_id
    tc_efs_id            = jsondecode(data.aws_s3_object.core_env_outputs.body).tc_efs_id
    region               = jsondecode(data.aws_s3_object.core_outputs.body).region
    kms_key_id           = jsondecode(data.aws_s3_object.core_outputs.body).kms_key_id
    base_ami             = nonsensitive(data.aws_ssm_parameter.base_ami.value)
    install_scripts_path = jsondecode(data.aws_s3_object.install_scripts.body).scripts_s3_path
    dc_url               = nonsensitive(data.aws_ssm_parameter.dc_url.value)
    rebake_seed          = local.rebake_seed
    dir_sha1             = sha1(join("", [for f in fileset(local.packer_dir, "*"): filesha1(format("%s/%s", local.packer_dir, f))]))
    common_dir_sha1      = sha1(join("", [for f in fileset(local.common_packer_dir, "*"): filesha1(format("%s/%s", local.common_packer_dir, f))]))
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
  -var 'instance_profile=${jsondecode(data.aws_s3_object.core_env_outputs.body).instance_profile_id}' \
  -var 'tc_efs_id=${jsondecode(data.aws_s3_object.core_env_outputs.body).tc_efs_id}' \
  -var 'region=${jsondecode(data.aws_s3_object.core_outputs.body).region}' \
  -var 'kms_key_id=${jsondecode(data.aws_s3_object.core_outputs.body).kms_key_id}' \
  -var 'base_ami=${nonsensitive(data.aws_ssm_parameter.base_ami.value)}' \
  -var 'machine_name=${nonsensitive(data.aws_ssm_parameter.fsc_master_hostname.value)}' \
  -var 'install_scripts_path=${jsondecode(data.aws_s3_object.install_scripts.body).scripts_s3_path}' \
  -var 'dc_user_secret_name=/teamcenter/shared/deployment_center/username' \
  -var 'dc_pass_secret_name=/teamcenter/shared/deployment_center/password' \
  -var 'dc_url=${nonsensitive(data.aws_ssm_parameter.dc_url.value)}' \
  -var 'ignore_tc_errors=${var.ignore_tc_errors}' \
  -var 'private_hosted_zone_name=${data.aws_route53_zone.private.name}' \
  -var 'private_hosted_zone_arn=${jsondecode(data.aws_s3_object.core_outputs.body).private_hosted_zone_arn}' \
  -var 'stage_name=bake_fsc' \
  -var 'start_fsc=true' \
  -var 'start_pool_mgr=${local.is_start_pool_mgr}' \
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


data "aws_ami" "fsc_master" {
  depends_on = [
    null_resource.packer
  ]

  most_recent = true
  owners      = ["self"]

  filter {
     name   = "tag:BuildUUID-tc-${nonsensitive(data.aws_ssm_parameter.fsc_master_hostname.value)}"
     values = [local.rebake_seed]
  }
}

resource "aws_ssm_parameter" "base_ami" {
  name           = "/teamcenter/${var.env_name}/enterprise_tier/fsc/master/base_ami"
  type           = "String"
  insecure_value = data.aws_ami.fsc_master.id
  overwrite      = true
}

resource "aws_ssm_parameter" "rebake_seed" {
  name           = "/teamcenter/${var.env_name}/enterprise_tier/fsc/master/rebake_seed"
  type           = "String"
  insecure_value = local.rebake_seed
  overwrite      = true
}

