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
  role_name  = "terratest-${random_string.prefix.result}-role"
  account_id = "237889007525"
  tags = {
    Application = local.role_name
    Account     = local.account_id
  }
}

module "module" {
  source = "../"

  role_name   = local.role_name
  description = "Policy created by Terratest"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Resource": [
      "arn:aws:iam::${local.account_id}:role/${local.role_name}"
    ]
  }
}
POLICY

  tags = local.tags
}

output "id" {
  value = module.module.id
}

output "arn" {
  value = module.module.arn
}

output "name" {
  value = module.module.name
}

output "path" {
  value = module.module.path
}

output "policy" {
  value = module.module.policy
}