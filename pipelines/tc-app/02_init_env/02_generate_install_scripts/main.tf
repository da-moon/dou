terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    local = {
      source = "hashicorp/local"
    }
  }

  required_version = "~> 1.1.9"
}

provider aws {
  region = var.region
}

locals {
  installation_prefix = jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix
  dc_name             = local.installation_prefix != "" ? "${local.installation_prefix}-tc-deployment-center" : "tc-deployment-center"
  bastion_name        = local.installation_prefix != "" ? "${local.installation_prefix}-tc-bastion" : "tc-bastion"
  changing_filename   = "latest_dir_${formatdate("YYYYMMDDhhmmss", timestamp())}"
  previous_filename   = length(data.aws_s3_objects.maybe_self_outputs.keys) > 0 ? lookup(jsondecode(data.aws_s3_object.self_outputs[0].body), "output_filename", local.changing_filename) : local.changing_filename
  output_filename     = var.force_regenerate ? local.changing_filename : local.previous_filename
  s3_uri              = "stage_outputs/03_generate_install_scripts/${var.env_name}/quick_deploy.xml"
}

data "aws_ssm_parameter" "rds_dns" { name = "/teamcenter/${var.env_name}/db/rds_dns" }

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
  prefix = "stage_outputs/03_generate_install_scripts/${var.env_name}/outputs.json"
}

data "aws_s3_object" "self_outputs" {
  count  = length(data.aws_s3_objects.maybe_self_outputs.keys)
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/03_generate_install_scripts/${var.env_name}/outputs.json"
}

data "aws_instance" "deployment_center" {
  filter {
    name   = "tag:Name"
    values = [local.dc_name]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

data "template_file" "quick_deploy" {
  template = "${file("${path.module}/../../../../environments/teamcenter/${var.env_name}/quick_deploy_configuration.xml")}"
}

module "generate_deployment_scripts" {
  depends_on = [
    aws_s3_object.quick_deploy
  ]
  source        = "../../../../components/terraform/ssm_command"
  instance_id   = data.aws_instance.deployment_center.id
  commands      = ["python3 /home/tc/generate_deployment_scripts.py ${var.region} \"${local.installation_prefix}\" ${var.artifacts_bucket_name} ${local.output_filename} ${jsondecode(data.aws_s3_object.core_env_outputs.body).wb_public_dns} s3://${var.artifacts_bucket_name}/${local.s3_uri}"]
  region        = var.region
  triggers = {
    env_sha1        = filesha1("../../../../environments/teamcenter/${var.env_name}/quick_deploy_configuration.xml")
    output_filename = local.output_filename
    tc_efs_id       = jsondecode(data.aws_s3_object.core_env_outputs.body).tc_efs_id
    rds_dns         = nonsensitive(data.aws_ssm_parameter.rds_dns.value)
  }
}

resource "aws_s3_object" "quick_deploy" {
  bucket       = var.artifacts_bucket_name
  key          = local.s3_uri
  content_type = "application/xml"
  content      = data.template_file.quick_deploy.rendered
}

data "aws_s3_object" "generate_scripts_output" {
  depends_on = [
    module.generate_deployment_scripts
  ]
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/03_generate_install_scripts/${var.env_name}/${local.output_filename}"
}

resource "aws_s3_object" "scripts_dir" {
  bucket       = var.artifacts_bucket_name
  key          = "stage_outputs/03_generate_install_scripts/${var.env_name}/outputs.json"
  content_type = "application/json"
  content      = jsonencode({
    scripts_s3_path = "${var.artifacts_bucket_name}/deployment_scripts/${var.env_name}/install/${data.aws_s3_object.generate_scripts_output.body}"
    output_filename = local.output_filename
  })
}
