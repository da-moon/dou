terraform {
  backend "s3" {
    bucket = "lsf-landing-zone-backend"
    key    = "state/terraform.tfstate"
    region = "us-west-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}