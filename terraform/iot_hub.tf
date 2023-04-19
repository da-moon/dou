data "azurerm_iothub_shared_access_policy" "fis_hub_iothubowner" {
  name                = "iothubowner"
  resource_group_name = azurerm_resource_group.fis_rs.name
  iothub_name         = azurerm_iothub.fis_hub.name
}

resource "azurerm_iothub" "fis_hub" {
  name                = "FIS-IoTHub"
  resource_group_name = azurerm_resource_group.fis_rs.name
  location            = azurerm_resource_group.fis_rs.location

  sku {
    name     = var.iot_hub_tier
    capacity = var.iot_hub_capacity
  }

  cloud_to_device {
    max_delivery_count = 30
    default_ttl        = "PT1H"
    feedback {
      time_to_live       = "PT1H10M"
      max_delivery_count = 15
      lock_duration      = "PT30S"
    }
  }

  tags = {
    project = "fis"
  }
}
