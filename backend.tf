terraform {
  backend "remote" {
    organization = "DoU-TFE"

    workspaces {
      prefix = "sentinel-datadog-"
    }
  }
}
