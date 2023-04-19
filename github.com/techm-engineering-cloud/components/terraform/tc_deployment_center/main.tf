
locals {
  prefix = var.installation_prefix != "" ? "${var.installation_prefix}-tc" : "tc"
}

data "aws_s3_object" "core_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/01_core_infra/outputs.json"
}

data "aws_subnet" "subnet_1" {
  id = var.lb_subnets[0]
}

data "aws_subnet" "subnet_2" {
  id = var.lb_subnets[1]
}

data "aws_vpc" "main" {
  id = data.aws_subnet.subnet_1.vpc_id
}

