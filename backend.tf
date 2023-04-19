terraform {
  backend "remote" {
    organization = "DoU-TFE"

    workspaces {
      prefix = "WaaS-"
    }
  }
}

#waas-plm-hub