
provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {
}


data "azurerm_resource_group" "example" {
				name = var.resource_group_name
}

data "azurerm_key_vault" "example" {
  name                = "test-mongodb2"
  resource_group_name = data.azurerm_resource_group.example.name
}

data "azurerm_key_vault_key" "example" {
  name         = "test"
  key_vault_id = data.azurerm_key_vault.example.id
}


resource "mongodbatlas_encryption_at_rest" "test" {
			project_id = var.project_id

		   azure_key_vault = {
				enabled             = true
				client_id           = var.client_id
				azure_environment   = "AZURE"
				subscription_id     = data.azurerm_client_config.current.subscription_id
				resource_group_name = data.azurerm_resource_group.example.name
				key_vault_name  	  = data.azurerm_key_vault.example.name
				key_identifier  	  = data.azurerm_key_vault_key.example.id
				secret  						= var.client_secret
				tenant_id  					= data.azurerm_client_config.current.tenant_id
			}
		}
