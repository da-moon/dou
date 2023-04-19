provider "aws" {
  region = local.region
}

locals {
  user            = "jestrada"
  region          = "us-west-1"
  allowed_sources = ["189.215.154.4/32"]
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.user}-vagrant-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "sandbox"
  }
}

resource "aws_security_group" "ec2" {
  name_prefix = "${local.user}-vagrant-"
  description = "sg for vagrant ec2"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = local.allowed_sources
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.allowed_sources
  }

  ingress {
    description = "Allow RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = local.allowed_sources
  }

  ingress {
    description = "Allow Winrm"
    from_port   = 5985
    to_port     = 5985
    protocol    = "tcp"
    cidr_blocks = local.allowed_sources
  }

  ingress {
    description = "Allow Winrm HTTPS"
    from_port   = 5986
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = local.allowed_sources
  }



  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Terraform   = "true"
    Environment = "sandbox"
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "${local.user}-vagrant-ssh-key"
  public_key = file("../vagrant.key.pub")
}

