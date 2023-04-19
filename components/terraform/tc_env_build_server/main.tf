
locals {
  prefix = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}" : "tc-${var.env_name}"
}

data "aws_subnet" "build" {
  id = var.build_subnet_id
}

data "aws_vpc" "main" {
  id = data.aws_subnet.build.vpc_id
}

data "aws_region" "current" {}

