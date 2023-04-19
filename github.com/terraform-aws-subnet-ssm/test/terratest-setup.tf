provider "aws" {
  region = "eu-central-1"
}

data "aws_region" "current" {}

resource "random_string" "prefix" {
  length  = 8
  upper   = false
  number  = false
  special = false
}

locals {
  tags = {
    Name        = "subnet-ssm-${random_string.prefix.result}"
    Application = "terraform-aws-subnet-ssm"
    Environment = "terratest"
  }
}

module "vpc" {
  source           = "github.com/DigitalOnUs/terraform-aws-vpc-ssm?ref=0.0.1"
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = local.tags
}

module "module" {
  source = "../"

  vpc_id     = module.vpc.id
  cidr_block = "10.0.1.0/24"

  allow_public_ip                 = true
  assign_ipv6_address_on_creation = false

  tags = local.tags
}

output "region" {
  value = data.aws_region.current.name
}

output "vpc_id" {
  value = module.vpc.id
}

output "arn" {
  value = module.module.arn
}

output "subnet_id" {
  value = module.module.id
}

output "ipv6_association_id" {
  value = module.module.ipv6_association_id
}

output "owner_id" {
  value = module.module.owner_id
}