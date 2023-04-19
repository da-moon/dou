
data "aws_s3_object" "core_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/01_core_infra/outputs.json"
}

data "aws_s3_object" "core_env_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/02_core_env/${var.env_name}/outputs.json"
}

data "aws_subnet" "build" {
  id = var.build_subnet_id
}

data "aws_vpc" "main" {
  id = data.aws_subnet.build.vpc_id
}

