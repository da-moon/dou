data "terraform_remote_state" "config" {
  backend = "atlas"

  config = {
    name = "saj/${var.atlas_env_base_name}-config"
  }
}

