terraform {
  backend "s3" {
    bucket  = "armory-terraform-state"
    encrypt = true
    key     = "./nginx/terraform.tfstate"
    region  = "us-west-2"
  }
}