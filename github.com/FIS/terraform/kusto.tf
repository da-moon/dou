resource "azurerm_kusto_cluster" "cluster" {
  name                = "fiskustocluster"
  location            = azurerm_resource_group.fis_rs.location
  resource_group_name = azurerm_resource_group.fis_rs.name

  sku {
    name     = "Standard_D13_v2"
    capacity = 2
  }

  engine = "V3"
}

resource "azurerm_kusto_database" "database" {
  name                = "fiskustodatabase"
  resource_group_name = azurerm_resource_group.fis_rs.name
  location            = azurerm_resource_group.fis_rs.location
  cluster_name        = azurerm_kusto_cluster.cluster.name
  hot_cache_period    = "P7D"
  soft_delete_period  = "P31D"
}

resource "azurerm_kusto_cluster_principal_assignment" "team_cluster_roles" {
  count    = length(data.azuread_user.users.*.id)

  name                = format("KustoPrincipalAssignment-%d",count.index)
  resource_group_name = azurerm_resource_group.fis_rs.name
  cluster_name        = azurerm_kusto_cluster.cluster.name

  tenant_id      = data.azurerm_client_config.current.tenant_id
  principal_id   = "${element(data.azuread_user.users.*.id, count.index)}"
  principal_type = "User"
  role           = "AllDatabasesAdmin"
}

resource "azurerm_kusto_database_principal_assignment" "team_database_roles" {
  count    = length(data.azuread_user.users.*.id)

  name                = format("KustoPrincipalAssignment-%d", count.index)
  resource_group_name = azurerm_resource_group.fis_rs.name
  cluster_name        = azurerm_kusto_cluster.cluster.name
  database_name       = azurerm_kusto_database.database.name

  tenant_id      = data.azurerm_client_config.current.tenant_id
  principal_id   = "${element(data.azuread_user.users.*.id, count.index)}"
  principal_type = "User"
  role           = "Admin"
}

data "azurerm_storage_account_blob_container_sas" "storage_account_blob_container_sas" {
  connection_string = azurerm_storage_account.fis_storage_account.primary_connection_string
  container_name    = azurerm_storage_container.fis_message_container.name
  https_only        = true

  start  = "2017-03-21"
  expiry = "2023-03-21"

  permissions {
    read   = true
    add    = false
    create = false
    write  = true
    delete = false
    list   = true
  }
}
