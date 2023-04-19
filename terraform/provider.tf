terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.24.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.22.0"
    }
    grafana = {
      source = "grafana/grafana"
      version = "1.28.1"
    }
  }
  backend "azurerm" {
    key                  = "mvp.terraform.tfstate"
  }

}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.az_service_principal
  client_secret   = var.az_client_secret
  tenant_id       = var.tenant_id
}


provider "azuread" {
  client_id     = var.az_service_principal
  client_secret = var.az_client_secret
  tenant_id     = var.tenant_id
}

provider "grafana" {
  url  = azurerm_dashboard_grafana.fis_grafana.endpoint
  auth = var.grafana_auth
}
