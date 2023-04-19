terraform {
  required_version = ">= 0.13.3"

  backend "s3" {
    bucket = "terratest-poc"
    key    = "tfstate/terraform-aws-ssh"
    region = "us-west-1"
  }
}
