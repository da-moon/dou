module "vpc" {
  source = "../modules/vpc"

  name = var.vpc_name
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.priv_sub
  public_subnets  = var.pub_sub

  enable_nat_gateway = var.gateway
  enable_vpn_gateway = var.gateway
}

module "security-group" {
  source              = "../modules/security-group"
  security_group_name = var.security_group_name
  vpc_id              = module.vpc.vpc_id
}


module "s3_bucket" {
  source = "../modules/s3"
  create = var.create
  bucket = var.bucket
  acl    = var.acl
}

module "iam" {
  source               = "../modules/iam"
  iam_role             = var.iam_role
  iam_instance_profile = var.iam_instance_profile
  iam_role_policy      = var.iam_role_policy
  bucket               = var.bucket

  depends_on = [
    module.s3_bucket
  ]
}

module "openzfs" {
  source              = "../modules/fsx"
  fsx_name            = var.fsx_name
  storage_capacity    = var.storage_capacity
  throughput_capacity = var.throughput_capacity
  subnet_ids          = [module.vpc.public_subnets[0]]
  security_group_ids  = [module.security-group.security_group_id]
}

resource "local_file" "fsx_dns" {
  content  = module.openzfs.fsx_openzfs_dns_name
  filename = "../terraform_output/fsx_openzfs_dns_name"
}
