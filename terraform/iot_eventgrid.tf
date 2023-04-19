
resource "azurerm_eventgrid_system_topic" "digital_twins" {
  name                   = "digitalTwinsUpdate"
  resource_group_name    = azurerm_resource_group.fis_rs.name
  location               = azurerm_resource_group.fis_rs.location
  source_arm_resource_id = azurerm_iothub.fis_hub.id
  topic_type             = "Microsoft.Devices.IoTHubs"
}


resource "azurerm_eventgrid_system_topic_event_subscription" "digital_twins_update" {
  name                = "dt-sub"
  system_topic        = azurerm_eventgrid_system_topic.digital_twins.name
  resource_group_name = azurerm_resource_group.fis_rs.name

  azure_function_endpoint {
    function_id = format("%s/functions/%s",azurerm_linux_function_app.fis_data_save.id, azurerm_linux_function_app.fis_data_save.name)
    max_events_per_batch = 1
    preferred_batch_size_in_kilobytes = 64
  }

  advanced_filtering_on_arrays_enabled = true

  included_event_types= ["Microsoft.Devices.DeviceTelemetry"]

  event_delivery_schema = "EventGridSchema"

  depends_on = [
    azurerm_eventgrid_system_topic.digital_twins
  ]
}
