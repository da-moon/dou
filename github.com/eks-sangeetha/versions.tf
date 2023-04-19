terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.9.4"
    }

    helm       = ">= 1.0, < 3.0"
    kubernetes = ">= 1.10.0, < 3.0.0"
    
  }

#  required_version = "~> 1.2.0"
}

