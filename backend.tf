terraform {
  backend "remote" {
    organization = "DoU-TFE"

    workspaces {
      prefix = "CaaS-"
    }
  }
}