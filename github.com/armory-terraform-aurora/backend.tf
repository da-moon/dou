terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    # The name of your Terraform Cloud organization.
    organization = "dou-armory"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "armory-aurora"
    }
  }
}