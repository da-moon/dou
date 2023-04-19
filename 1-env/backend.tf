terraform {
  backend "s3" {
    bucket = "backend-lsf-eh"
    key    = "env/terraform.tfstate"
    region = "us-east-2"
  }
}
