terraform {
  backend "s3" {
    bucket = "backend-lsf-eh"
    key    = "ec2-instance/terraform.tfstate"
    region = "us-east-2"
  }
}