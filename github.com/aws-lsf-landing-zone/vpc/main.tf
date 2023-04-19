module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.priv_sub
  public_subnets  = var.pub_sub

  enable_nat_gateway = var.gateway
  enable_vpn_gateway = var.gateway
}