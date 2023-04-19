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

data "aws_s3_object" "core_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/01_core_infra/outputs.json"
}

provider aws {
  region = var.region
}

data "aws_ssm_parameter" "web_hostname" { name = "/teamcenter/${var.env_name}/web_tier/hostname" }
data "aws_ssm_parameter" "aw_gateway_hostname" { name = "/teamcenter/${var.env_name}/aw_gateway/hostname" }

data "aws_s3_object" "bake_tc_webserver_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/env-${var.env_name}/bake_web/outputs.json"
}

data "aws_s3_object" "core_env_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/02_core_env/${var.env_name}/outputs.json"
}

locals {
  is_aw_tg_different = jsondecode(data.aws_s3_object.core_env_outputs.body).wb_lb_target_group_arns != jsondecode(data.aws_s3_object.core_env_outputs.body).awg_target_group
  target_group_arns  = local.is_aw_tg_different ? [jsondecode(data.aws_s3_object.core_env_outputs.body).wb_lb_target_group_arns, jsondecode(data.aws_s3_object.core_env_outputs.body).awg_target_group] : [jsondecode(data.aws_s3_object.core_env_outputs.body).wb_lb_target_group_arns]
  has_gateway        = data.aws_ssm_parameter.web_hostname.value == data.aws_ssm_parameter.aw_gateway_hostname.value
}

module "webserver" {
  source                 = "../../../../components/terraform/tc_webserver"
  installation_prefix    = jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix
  ami_id                 = jsondecode(data.aws_s3_object.bake_tc_webserver_outputs.body).webserver_ami_id
  ssh_key_name           = jsondecode(data.aws_s3_object.core_outputs.body).ssh_key_name
  iam_instance_profile   = jsondecode(data.aws_s3_object.core_env_outputs.body).instance_profile_id
  wb_security_group_id   = jsondecode(data.aws_s3_object.core_env_outputs.body).wb_security_group_id
  private_env_subnet_ids = jsondecode(data.aws_s3_object.core_env_outputs.body).private_env_subnet_ids
  target_group_arns      = local.target_group_arns
  vpc_id                 = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id
  max_instances          = var.machines.web_tier.max_instances
  min_instances          = var.machines.web_tier.min_instances
  instance_type          = var.machines.web_tier.instance_type
  machine_name           = nonsensitive(data.aws_ssm_parameter.web_hostname.value)
  env_name               = var.env_name
  has_gateway            = local.has_gateway
}


