#TODO : Make dyanmic for deployements
# # Backend

terraform {
  backend "s3" {
    bucket = "oss-bucket-dev"
    key    = "azure-scg-django"
    region = "us-west-2"
  }
}


# } # Terraform linked projects ###
#
data "terraform_remote_state" "landing_zone" {
  backend = "remote"

  config = {
    organization = "DOU-TFE"
    workspaces = {
      name = var.landing_zone
    }
  }
}
