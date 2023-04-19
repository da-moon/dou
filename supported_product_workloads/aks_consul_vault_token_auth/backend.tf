terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "DoU-TFE"

    workspaces {
      prefix = "aks-deploy-"
    }
  }
}
