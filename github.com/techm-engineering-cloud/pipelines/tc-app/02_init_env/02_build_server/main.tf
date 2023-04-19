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

provider "aws" {
  region = var.region
}

data "aws_ssm_parameter" "rds_dns" { name = "/teamcenter/${var.env_name}/db/rds_dns" }
data "aws_ssm_parameter" "db_host" { name = "/teamcenter/${var.env_name}/db/hostname" }
data "aws_ssm_parameter" "db_sid" { name = "/teamcenter/${var.env_name}/db/oracle_sid" }

data "aws_s3_object" "core_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/01_core_infra/outputs.json"
}

data "aws_s3_object" "core_env_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/02_core_env/${var.env_name}/outputs.json"
}

data "aws_instance" "build_server" {
  depends_on = [
    module.build_server
  ]

  filter {
    name   = "tag:Name"
    values = [var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-build-server" : "tc-${var.env_name}-build-server"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

locals {
  delete_data = var.delete_db_data ? "delete" : ""
}

module "build_server" {
  source                = "../../../../components/terraform/tc_env_build_server"
  installation_prefix   = var.installation_prefix
  env_name              = var.env_name
  subnet_ids            = jsondecode(data.aws_s3_object.core_env_outputs.body).private_env_subnet_ids
  build_subnet_id       = jsondecode(data.aws_s3_object.core_outputs.body).public_subnet_ids[0]
  kms_key_id            = jsondecode(data.aws_s3_object.core_outputs.body).kms_key_id
  instance_type         = var.machines.build_server.instance_type
  artifacts_bucket_name = var.artifacts_bucket_name 
  hosted_zone_id        = jsondecode(data.aws_s3_object.core_outputs.body).private_hosted_zone_id
  tc_efs_id             = jsondecode(data.aws_s3_object.core_env_outputs.body).tc_efs_id
  ssh_key_name          = jsondecode(data.aws_s3_object.core_outputs.body).ssh_key_name
  force_rebake          = var.force_rebake
  keystore_secret_name  = jsondecode(data.aws_s3_object.core_env_outputs.body).ms_keystore_secret_name
}

module "init_db" {
  source      = "../../../../components/terraform/ssm_command"
  instance_id = data.aws_instance.build_server.id
  commands    = ["/home/tc/db/init_db.sh ${local.delete_data}"]
  region      = var.region
  triggers = {
    rds_dns   = nonsensitive(data.aws_ssm_parameter.rds_dns.value)
    db_host   = nonsensitive(data.aws_ssm_parameter.db_host.value)
    db_sid    = nonsensitive(data.aws_ssm_parameter.db_sid.value)
    delete    = local.delete_data
    tc_efs_id = jsondecode(data.aws_s3_object.core_env_outputs.body).tc_efs_id
  }
}

