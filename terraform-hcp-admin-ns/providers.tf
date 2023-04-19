terraform {
  required_version = ">=1.2.0"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">=2.22.1"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">=0.26.1"
    }
  }
}
