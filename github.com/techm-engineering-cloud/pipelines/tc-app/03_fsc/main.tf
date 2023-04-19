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

provider aws {
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

module "fsc_master" {
  source                = "../../../components/terraform/tc_fsc_master"
  env_name              = var.env_name
  instance_type         = var.machines.enterprise_tier.instance_type
  artifacts_bucket_name = var.artifacts_bucket_name 
  force_rebake          = var.force_rebake
  ignore_tc_errors      = var.ignore_tc_errors
}

