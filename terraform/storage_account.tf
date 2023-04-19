resource "azurerm_storage_account" "fis_storage_account" {
  name                     = "fissc"
  resource_group_name      = azurerm_resource_group.fis_rs.name
  location                 = azurerm_resource_group.fis_rs.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "fis_message_container" {
  name                  = "fismessagecontainer"
  storage_account_name  = azurerm_storage_account.fis_storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "fis_FilterJPHTarget_container" {
  name                  = "fis-filterjphtarget-container"
  storage_account_name  = azurerm_storage_account.fis_storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "fis_FilterUnits_container" {
  name                  = "fis-filterunits-container"
  storage_account_name  = azurerm_storage_account.fis_storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "fis_FilterStateCode_container" {
  name                  = "fis-filterstatecode-container"
  storage_account_name  = azurerm_storage_account.fis_storage_account.name
  container_access_type = "private"
}


// Custom role for only reading containers
data "azuread_users" "users" {
  user_principal_names = ["atul.mehta1_techmahindra.com#EXT#@digitalonus01.onmicrosoft.com"]
}

resource "azurerm_role_assignment" "example" {
  count = length(data.azuread_users.users.user_principal_names)

  scope              = azurerm_resource_group.fis_rs.id
  role_definition_name = "Reader"
  principal_id       = data.azuread_users.users.object_ids[count.index]
}
