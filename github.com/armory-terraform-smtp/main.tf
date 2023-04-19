terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.60.0"
    }
  }

  required_version = ">= 1.0.2"
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
  shared_credentials_file = var.aws_credentials_location
  profile                 = var.aws_profile_name
}

module "module_iam" {
  source = "./modules/iam"
  smtp_user = var.smtp_user
  policy_arn = var.policy_arn
}

module "module_aws_ses" {
  source = "./modules/aws_ses"
  mail_identity = var.mail_identity
}

module "module_aws_s3" {
  source = "./modules/aws_s3"
  mail_from = module.module_aws_ses.email_identity
  seshost = var.smtp_endpoint
  sesusername = module.module_iam.smtp_user_id
  sespassword = module.module_iam.smtp_password
  ss_file_name = var.ss_file_name
  ss_file_location = var.ss_file_location
  bucket_name = var.bucket_name
}