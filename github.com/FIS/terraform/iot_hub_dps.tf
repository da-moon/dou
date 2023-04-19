resource "azurerm_iothub_dps" "fis_hub_dps" {
  name = "FIS-IoTHub-Dps"
  resource_group_name = azurerm_resource_group.fis_rs.name
  location = azurerm_resource_group.fis_rs.location
  allocation_policy = "Hashed"

  sku {
    name =var.iot_hub_tier
    capacity = var.iot_hub_capacity
  }

  linked_hub {
    location          = azurerm_resource_group.fis_rs.location
    connection_string = data.azurerm_iothub_shared_access_policy.fis_hub_iothubowner.primary_connection_string
  }

  tags = {
    project = "fis"
  }
}
resource "azurerm_iothub_dps_certificate" "fis_hub_dps_certificate" {
  name                = "FIS-IoTHub-Dps-Cert"
  resource_group_name = azurerm_resource_group.fis_rs.name
  iot_dps_name        = azurerm_iothub_dps.fis_hub_dps.name

  certificate_content = filebase64("fis.root.ca.cert.pem")
}
