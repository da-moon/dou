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

module "file_server" {
  source                = "../../../components/terraform/tc_file_server"
  artifacts_bucket_name = var.artifacts_bucket_name
  env_name              = var.env_name
  installation_prefix   = jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix
  force_rebake          = var.force_rebake
  ssh_key_name          = jsondecode(data.aws_s3_object.core_outputs.body).ssh_key_name
  max_instances         = var.machines.file_servers.max_instances
  min_instances         = var.machines.file_servers.min_instances
  instance_type         = var.machines.file_servers.instance_type
  build_subnet_id       = jsondecode(data.aws_s3_object.core_outputs.body).public_subnet_ids[0]
  lb_subnets            = jsondecode(data.aws_s3_object.core_outputs.body).public_subnet_ids
  instance_subnets      = jsondecode(data.aws_s3_object.core_env_outputs.body).private_env_subnet_ids
}

