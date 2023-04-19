module "vpc" {
  source  = "app.terraform.io/DoU-TFE/vpc-ssm/aws"
  version = "0.0.1"

  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy

  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_classiclink               = var.enable_classiclink
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  tags = var.tags
}

module "subnet" {
  source  = "app.terraform.io/DoU-TFE/subnet-ssm/aws"
  version = "0.0.1"

  for_each = { for key, value in var.subnet_config : key => value }

  vpc_id          = module.vpc.id
  cidr_block      = each.value.cidr_block
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  allow_public_ip = lookup(each.value, "allow_public_ip", false)

  availability_zone    = lookup(each.value, "availability_zone", null)
  availability_zone_id = lookup(each.value, "availability_zone_id", null)

  assign_ipv6_address_on_creation = lookup(each.value, "assign_ipv6_address_on_creation", false)

  tags = var.tags
}

module "security_group" {
  source  = "app.terraform.io/DoU-TFE/security-group-ssm/aws"
  version = "0.0.1"

  for_each = { for key, value in var.securitygroup_config : key => value }

  vpc_id       = module.vpc.id
  sg_name      = lookup(each.value, "securitygroup_name", null)
  description  = lookup(each.value, "description", "Managed by Terraform")
  delete_rules = lookup(each.value, "sg_delete_rules", false)

  ingress_rules = lookup(each.value, "sg_ingress_rules", [])
  egress_rules  = lookup(each.value, "sg_egress_rules", [])

  tags = var.tags
}