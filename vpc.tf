data "aws_route53_zone" "douterraform" {
  name = var.domain
}

## Subnet Configuration
 resource "aws_subnet" "caas_public" {
   count                   = 2
   vpc_id                  = module.vpc.vpc_id
   cidr_block              = var.public_subnets[count.index]
   map_public_ip_on_launch = "true"
   availability_zone       = var.azs_publics[count.index]
   tags = {
     Name        = element(var.public_subnets_name, count.index)
     Project     = var.project_name
     Environment = var.run_env
   }
 }


resource "aws_subnet" "caas_private" {
  count                   = 2
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = var.azs_privates[count.index]
  map_public_ip_on_launch = "false"
  tags = {
    Name        = element(var.private_subnets_name, count.index)
    Project     = var.project_name
    Environment = var.run_env
  }
}

# Configure VPC Creation Module
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.44.0
module "vpc" {
  source           = "terraform-aws-modules/vpc/aws"
  version          = "2.44.0"
  name             = "${var.project_name}-vpc"
  cidr             = var.cidr_block
  create_igw       = false
  instance_tenancy = var.instance_tenancy

  azs                  = [var.azs_public, var.azs_private]
  enable_nat_gateway   = false
  enable_vpn_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Terraform   = "true"
    Environment = var.run_env
    Project     = var.project_name
  }

}

