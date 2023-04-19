provider "aws" {
  region = "ca-central-1"
}

resource "random_string" "prefix" {
  length  = 8
  upper   = false
  number  = false
  special = false
}

locals {
  tags = {
    Name        = "route-table-${random_string.prefix.result}-ssm"
    Application = "terraform-aws-route-table-ssm"
    Environment = "terratest"
  }
}

data "aws_region" "current" {}

module "vpc" {
  source  = "app.terraform.io/DoU-TFE/vpc-ssm/aws"
  version = "0.0.1"

  cidr_block                       = "10.20.0.0/16"
  assign_generated_ipv6_cidr_block = true

  tags = local.tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.id

  tags = local.tags
}

resource "aws_egress_only_internet_gateway" "egress_igw" {
  vpc_id = module.vpc.id

  tags = local.tags
}

module "subnet" {
  source = "github.com/DigitalOnUs/terraform-aws-subnet-ssm?ref=0.0.1"

  vpc_id            = module.vpc.id
  cidr_block        = "10.20.1.0/24"
  availability_zone = "ca-central-1a"
  allow_public_ip   = true

  tags = local.tags
}

module "module" {
  source = "../"

  vpc_id = module.vpc.id

  route_objects = [{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    },
    {
      ipv6_cidr_block        = "::/0"
      egress_only_gateway_id = aws_egress_only_internet_gateway.egress_igw.id
    }
  ]

  assoc_subnet = [module.subnet.id]

  tags = local.tags
}

output "aws_region" {
  value = data.aws_region.current.name
}

output "vpc_id" {
  value = module.vpc.id
}

output "subnet_id" {
  value = module.subnet.id
}

### Module outputs
output "id" {
  value = module.module.id
}

output "arn" {
  value = module.module.arn
}

output "owner_id" {
  value = module.module.owner_id
}

output "association_id_subnet" {
  value = module.module.association_id_subnet
}