provider "aws" {
  region = "us-west-2"
}

resource "random_string" "prefix" {
  length  = 8
  upper   = false
  number  = false
  special = false
}

locals {
  name = "terratest-${random_string.prefix.result}-role"

  tags = {
    Application = local.name
  }
}

data "aws_caller_identity" "current" {}

module "module" {
  source = "../"

  name   = local.name
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": { "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" },
      "Effect": "Allow"
    }
  ]
}
POLICY

  tags = local.tags
}

output "role_id" {
  value = module.module.role_id
}

output "role_name" {
  value = module.module.role_name
}

output "role_arn" {
  value = module.module.arn
}

output "create_date" {
  value = module.module.create_date
}