terraform {
  backend "s3" {
    bucket = "oss-bucket-dev"
    key    = "pld-enterprise-server"
    region = "us-west-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.13.0"
    }
  }
}
