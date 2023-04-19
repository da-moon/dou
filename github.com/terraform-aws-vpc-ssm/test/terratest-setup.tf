provider "aws" {
  region = "eu-central-1"
}

resource "random_string" "prefix" {
  length  = 8
  upper   = false
  number  = false
  special = false
}

locals {
  tags = {
    Name        = "vpc-ssm-${random_string.prefix.result}"
    Application = "terraform-aws-vpc-ssm"
    Environment = "terratest"
  }
}

module "module" {
  source = "../"

  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  enable_dns_support   = false
  enable_dns_hostnames = false

  enable_classiclink             = false
  enable_classiclink_dns_support = false

  assign_generated_ipv6_cidr_block = false

  tags = local.tags
}

output "vpc_arn" {
  value = module.module.vpc_arn
}

output "id" {
  value = module.module.id
}

output "cidr_block" {
  value = module.module.cidr_block
}

output "owner_id" {
  value = module.module.owner_id
}

output "ipv6_cidr_block" {
  value = module.module.ipv6_cidr_block
}

output "main_route_table_id" {
  value = module.module.main_route_table_id
}

output "default_security_group_id" {
  value = module.module.default_security_group_id
}

output "default_network_acl_id" {
  value = module.module.default_security_group_id
}

output "default_route_table_id" {
  value = module.module.default_route_table_id
}

output "ipv6_association_id" {
  value = module.module.ipv6_association_id
}