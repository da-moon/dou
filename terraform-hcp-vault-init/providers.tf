terraform {
  required_version = ">= 1.2.0"
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = ">=0.10.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">=0.26.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.51.0"
    }
  }
}
