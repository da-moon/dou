provider "aws" {
  region = "us-west-2"
}

locals {
  tags = {
    Environment = "Terratest"
    Application = "Group-${random_string.prefix.result}"
  }
}

resource "random_string" "prefix" {
  length  = 8
  upper   = false
  number  = false
  special = false
}

module "user" {
  source = "github.com/DigitalOnUs/terraform-aws-iam-user-ssm?ref=reorganize"

  user_name    = "terratest-user-${random_string.prefix.result}"
  path         = "/"
  user_destroy = false
  key_status   = "Active"

  tags = local.tags
}

module "module" {
  source = "../"

  name = "terratest-${random_string.prefix.result}-group"
  path = "/"

  users = [module.user.user_name]
}

output "id" {
  value = module.module.group_id
}

output "name" {
  value = module.module.group_name
}

output "arn" {
  value = module.module.arn
}

output "users" {
  value = module.module.users
}