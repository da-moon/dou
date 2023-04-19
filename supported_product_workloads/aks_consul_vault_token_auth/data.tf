data "terraform_remote_state" "landing_zone" {

  backend = "remote"

  config = {
    organization = "DOU-TFE"
    workspaces = {
      name = var.landing_zone
    }
  }
}
