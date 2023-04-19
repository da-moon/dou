### Call The Module For Testing ###
module "alb-asg-pattern" {
  source                 = "../"
  name                   = var.name
  mandatory_tags         = var.mandatory_tags
  additional_tags        = var.additional_tags
  iam_instance_profile   = var.iam_instance_profile
  instance_type          = var.instance_type
  min_size               = var.min_size
  max_size               = var.max_size
  mixed_instances_policy = var.mixed_instances_policy
  desired_capacity       = var.desired_capacity
  https_listeners        = var.https_listeners
  environment            = var.environment
  target_groups          = var.target_groups
  block_device_mappings  = var.block_device_mappings
  capacity_rebalance     = var.capacity_rebalance
  os                     = var.os
  account_name           = var.account_name
  ami_name_tag           = var.ami_name_tag
  ebs_kms_key_alias      = var.ebs_kms_key_alias
  ec2_sg_name_search     = var.ec2_sg_name_search
  alb_sg_name_search     = var.alb_sg_name_search
}

data "aws_region" "current" {}

variable "vault_token" {
  description = "Vault token"
  type        = string
}

provider "vault" {
  address         = "https://vault-cldsvc-prod.corp.internal.companyA.com/"
  skip_tls_verify = true
  token           = var.vault_token
}

data "vault_aws_access_credentials" "creds" {
  backend = "aws"
  role    = var.vault_role_name
  type    = "sts"
}

provider "aws" {
  region     = "us-east-1"
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
  token      = data.vault_aws_access_credentials.creds.security_token
}

data "aws_caller_identity" "current" {}

data "aws_autoscaling_group" "current" {
  name = module.alb-asg-pattern.autoscaling_group_name

  depends_on = [
    module.alb-asg-pattern
  ]
}

