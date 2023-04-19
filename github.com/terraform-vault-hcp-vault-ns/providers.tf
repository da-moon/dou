terraform {
  required_providers {
    vault = {
      source                = "hashicorp/vault"
      version               = ">=2.22.1"
      configuration_aliases = [vault.admin]
    }

    tfe = {
      source  = "hashicorp/tfe"
      version = ">=0.26.1"
    }
  }
}
