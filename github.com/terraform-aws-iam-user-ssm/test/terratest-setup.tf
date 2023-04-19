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
  name = "terratest-${random_string.prefix.result}-user"
  tags = {
    Application = local.name
  }
}

module "module" {
  source = "../"

  user_name    = local.name
  path         = "/"
  user_destroy = false
  key_status   = "Active"

  tags = local.tags
}

output "name" {
  value = module.module.user_name
}

output "encrypted_secret" {
  value = module.module.encrypted_secret
}

output "arn" {
  value = module.module.arn
}

output "access_key" {
  value = module.module.access_key
}

output "secret" {
  value = module.module.secret
}