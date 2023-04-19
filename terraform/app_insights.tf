resource "azurerm_log_analytics_workspace" "fis_workspace" {
  name                = "fis-workspace"
  location            = azurerm_resource_group.fis_rs.location
  resource_group_name = azurerm_resource_group.fis_rs.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "fis_app_insights" {
  name                = "app_insights"
  location            = var.app_insights_region
  resource_group_name = azurerm_resource_group.fis_rs.name
  workspace_id        = azurerm_log_analytics_workspace.fis_workspace.id
  application_type    = "other"
}
