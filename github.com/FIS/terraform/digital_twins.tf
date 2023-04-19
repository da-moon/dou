// Digital Twins
data "azuread_service_principal" "service_principal" {
  application_id = var.az_service_principal
}

resource "azurerm_digital_twins_instance" "fis_digital_twins" {
  name                = "FIS-DT"
  resource_group_name = azurerm_resource_group.fis_rs.name
  location            = azurerm_resource_group.fis_rs.location

  tags = {
    project = "fis"
  }
}

resource "azurerm_digital_twins_endpoint_eventhub" "dt_events" {
  name                                 = "telemetry-events"
  digital_twins_id                     = azurerm_digital_twins_instance.fis_digital_twins.id
  eventhub_primary_connection_string   = azurerm_eventhub_authorization_rule.fis_digital_twins_send_rule.primary_connection_string
  eventhub_secondary_connection_string = azurerm_eventhub_authorization_rule.fis_digital_twins_send_rule.secondary_connection_string
}

resource "azurerm_role_assignment" "service_princial_data_owner" {
  scope = azurerm_digital_twins_instance.fis_digital_twins.id
  principal_id = data.azuread_service_principal.service_principal.id
  role_definition_name = "Azure Digital Twins Data Owner"

  depends_on = [
    azurerm_digital_twins_instance.fis_digital_twins
  ]
}

resource "azurerm_role_assignment" "data_owner_users" { 
  count = length(data.azuread_user.users.*.id)
  scope = azurerm_digital_twins_instance.fis_digital_twins.id
  principal_id = "${element(data.azuread_user.users.*.id, count.index)}"
  role_definition_name = "Azure Digital Twins Data Owner"

  depends_on = [
    azurerm_digital_twins_instance.fis_digital_twins
  ]
}
