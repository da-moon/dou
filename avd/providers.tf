terraform {
  required_version = ">= 1.1.6"

  required_providers {
    azuread = {
      source  = "azuread"
      version = ">= 2.18.0"
    }

    azurerm = {
      source  = "azurerm"
      version = ">= 2.98.0"
    }

    random = {
      source  = "random"
      version = ">= 3.1.0"
    }

    time = {
      source  = "time"
      version = ">= 0.7.2"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.az_subscription_id
  client_id       = var.az_service_principal
  client_secret   = var.az_client_secret
  tenant_id       = var.az_tenant_id
}

provider "azuread" {
  client_id     = var.az_service_principal
  client_secret = var.az_client_secret
  tenant_id     = var.az_tenant_id
}
