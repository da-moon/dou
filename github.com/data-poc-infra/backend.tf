terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.51.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "data-poc"
    storage_account_name = "datatfstate"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }
}