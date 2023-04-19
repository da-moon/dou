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
    Name        = "sg-ssm-${random_string.prefix.result}"
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

  vpc_id      = module.vpc.id
  sg_name     = "sg${random_string.prefix.result}"
  description = "Allow TLS inbound traffic"

  ingress_rules = [{
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.cidr_block]
    },
    {
      description = "TLS from VPC"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = [module.vpc.cidr_block]
  }]

  egress_rules = [{
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }]

  tags = local.tags
}

output "region" {
  value = data.aws_region.current.name
}

output "vpc_id" {
  value = module.vpc.id
}

output "id" {
  value = module.module.id
}

output "name" {
  value = module.module.name
}

output "arn" {
  value = module.module.arn
}

output "owner_id" {
  value = module.module.owner_id
}