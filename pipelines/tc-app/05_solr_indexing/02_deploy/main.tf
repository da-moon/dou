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

data "aws_ssm_parameter" "indexing_engine_dns" { name = "/teamcenter/${var.env_name}/indexing_engine/dns" }

data "aws_s3_object" "core_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/01_core_infra/outputs.json"
}

provider aws {
  region = var.region
}

data "aws_s3_object" "bake_solr_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/env-${var.env_name}/bake_solr/outputs.json"
}

data "aws_s3_object" "core_env_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/02_core_env/${var.env_name}/outputs.json"
}

module "solr_indexing" {
  source                   = "../../../../components/terraform/tc_solr_indexing"
  installation_prefix      = jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix
  ami_id                   = jsondecode(data.aws_s3_object.bake_solr_outputs.body).solr_indexing_ami_id
  ssh_key_name             = jsondecode(data.aws_s3_object.core_outputs.body).ssh_key_name
  iam_instance_profile     = jsondecode(data.aws_s3_object.core_env_outputs.body).instance_profile_id
  sl_security_group_id     = jsondecode(data.aws_s3_object.core_env_outputs.body).sl_security_group_id
  private_env_subnet_ids   = jsondecode(data.aws_s3_object.core_env_outputs.body).private_env_subnet_ids
  sl_lb_target_group       = jsondecode(data.aws_s3_object.core_env_outputs.body).sl_lb_target_group_arns
  vpc_id                   = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id
  machine_name             = nonsensitive(data.aws_ssm_parameter.indexing_engine_dns.value)
  max_instances = var.machines.solr_indexing.max_instances
  min_instances = var.machines.solr_indexing.min_instances
  instance_type = var.machines.solr_indexing.instance_type
  env_name      = var.env_name
}

