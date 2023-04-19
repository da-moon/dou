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
    Name        = "network-spw-${random_string.prefix.result}"
    Application = "terraform-aws-network-spw"
    Environment = "terratest"
  }
}

module "module" {
  source = "../"

  cidr_block = "172.16.0.0/16"

  #### SUBNET
  subnet_config = [
    {
      cidr_block        = "172.16.10.0/24"
      availability_zone = "eu-central-1a"
    },
    {
      cidr_block = "172.16.30.0/24"
    }
  ]

  #### SECURITY GROUP
  securitygroup_config = [{
    securitygroup_name = "sg${random_string.prefix.result}"
    description        = "Allow TLS inbound traffic"

    ingress_rules = [{
      description = "TLS from VPC"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      },
      {
        description = "TLS from VPC"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
    }]

    egress_rules = [{
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }]
  }]

  tags = local.tags
}

output "region" {
  value = data.aws_region.current.name
}

output "vpc_arn" {
  value = module.module.vpc_arn
}

output "vpc_id" {
  value = module.module.vpc_id
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

output "ipv6_association_id" {
  value = module.module.ipv6_association_id
}

###### SUBNET
output "subnet_id" {
  value = module.module.subnet_id
}

output "subnet_arn" {
  value = module.module.subnet_arn
}

##### SECURITY GROUP
output "sg_id" {
  value = module.module.sg_id
}

output "sg_name" {
  value = module.module.sg_name
}

output "sg_arn" {
  value = module.module.sg_arn
}