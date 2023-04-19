resource "azurerm_dashboard_grafana" "fis_grafana" {
  name                              = "fis-grafana"
  location                          = azurerm_resource_group.fis_rs.location
  resource_group_name               = azurerm_resource_group.fis_rs.name
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = false
  public_network_access_enabled     = true

  identity {
    type = "SystemAssigned"
  }

  tags = {
    project = "fis"
  }
}

resource "azurerm_role_assignment" "grafana_data_owner_users" { 
  count = length(data.azuread_user.users.*.id)
  scope = azurerm_dashboard_grafana.fis_grafana.id
  principal_id = "${element(data.azuread_user.users.*.id, count.index)}"
  role_definition_name = "Grafana Admin"

  depends_on = [
    azurerm_dashboard_grafana.fis_grafana
  ]
}

resource "azurerm_role_assignment" "grafana_data_viewer_users" { 
  count = length(data.azuread_user.external_users.*.id)
  scope = azurerm_dashboard_grafana.fis_grafana.id
  principal_id = "${element(data.azuread_user.external_users.*.id, count.index)}"
  role_definition_name = "Grafana Viewer"

  depends_on = [
    azurerm_dashboard_grafana.fis_grafana
  ]
}