terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
}

# Configure the providers
provider "azurerm" {
  features {}
}
/*
provider "github" {}
provider "gitlab" {}
provider "azuread" {}
*/
