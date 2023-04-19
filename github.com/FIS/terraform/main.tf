
resource "azurerm_resource_group" "fis_rs" {
  name     = var.rs_name
  location = var.region

  tags = {
    project = "fis"
  }
}

data "azurerm_client_config" "current" {}

data "azuread_user" "users" {
  count    = length(var.digital_twins_users)

  user_principal_name = element(var.digital_twins_users, count.index)
}

data "azuread_user" "external_users" {
  count    = length(var.external_users)

  user_principal_name = element(var.external_users, count.index)
}
