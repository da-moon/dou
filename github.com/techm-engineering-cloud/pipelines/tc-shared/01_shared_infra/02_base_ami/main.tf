terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = "~> 1.1.9"
}

provider "aws" {
  region = var.region
}


module "base_ami" {
  source                = "../../../../components/terraform/tc_base_ami"
  artifacts_bucket_name = var.artifacts_bucket_name
  force_rebake          = var.force_rebake
}
