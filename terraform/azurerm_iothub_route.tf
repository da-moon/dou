resource "azurerm_iothub_route" "fis_iothub_route_storage_filterjphtarget" {
  resource_group_name = azurerm_resource_group.fis_rs.name
  iothub_name         = azurerm_iothub.fis_hub.name
  name                = "storage_FilterJPHTarget"
  source         = "DeviceMessages"
  condition      = "is_defined($body.JPH_Target)"
  endpoint_names = [azurerm_iothub_endpoint_storage_container.fis_iothub_endpointcontainer_filterjphtarget.name]
  enabled        = true
  depends_on = [azurerm_iothub_endpoint_storage_container.fis_iothub_endpointcontainer_filterjphtarget]
}

resource "azurerm_iothub_route" "fis_iothub_route_storage_filterunits" {
  resource_group_name = azurerm_resource_group.fis_rs.name
  iothub_name         = azurerm_iothub.fis_hub.name
  name                = "storage_FilterUnits"
  source         = "DeviceMessages"
  condition      = "is_defined($body.Units_Total)"
  endpoint_names = [azurerm_iothub_endpoint_storage_container.fis_iothub_endpointcontainer_filterunits.name]
  enabled        = true
  depends_on = [azurerm_iothub_endpoint_storage_container.fis_iothub_endpointcontainer_filterunits]
}

resource "azurerm_iothub_route" "fis_iothub_route_storage_filterstatecode" {
  resource_group_name = azurerm_resource_group.fis_rs.name
  iothub_name         = azurerm_iothub.fis_hub.name
  name                = "storage_FilterStateCode"
  source         = "DeviceMessages"
  condition      = "is_defined($body.State_Code)"
  endpoint_names = [azurerm_iothub_endpoint_storage_container.fis_iothub_endpointcontainer_filterstatecode.name]
  enabled        = true
  depends_on = [azurerm_iothub_endpoint_storage_container.fis_iothub_endpointcontainer_filterstatecode]
}

resource "azurerm_iothub_route" "fis_iothub_route_filterstatecode" {
  resource_group_name = azurerm_resource_group.fis_rs.name
  iothub_name         = azurerm_iothub.fis_hub.name
  name                = "FilterStateCode"
  source         = "DeviceMessages"
  condition      = "is_defined($body.State_Code)"
  endpoint_names = [azurerm_eventgrid_system_topic_event_subscription.filter_state_code.name]
  enabled        = true
  depends_on = [azurerm_iothub_endpoint_servicebus_queue.fis_iothub_endpointservicebusqueue_filterstatecode]
}

resource "azurerm_iothub_route" "fis_iothub_route_filterunits" {
  resource_group_name = azurerm_resource_group.fis_rs.name
  iothub_name         = azurerm_iothub.fis_hub.name
  name                = "FilterUnits"
  source         = "DeviceMessages"
  condition      = "is_defined($body.Units_Total)"
  endpoint_names = [azurerm_eventgrid_system_topic_event_subscription.filter_units.name]
  enabled        = true
  depends_on = [azurerm_iothub_endpoint_servicebus_queue.fis_iothub_endpointservicebusqueue_filterunits]
}

resource "azurerm_iothub_route" "fis_iothub_route_filterjphtarget" {
  resource_group_name = azurerm_resource_group.fis_rs.name
  iothub_name         = azurerm_iothub.fis_hub.name
  name                = "FilterJPHTarget"
  source         = "DeviceMessages"
  condition      = "is_defined($body.JPH_Target)"
  endpoint_names = [azurerm_eventgrid_system_topic_event_subscription.filter_jph.name]
  enabled        = true
  depends_on = [azurerm_iothub_endpoint_servicebus_queue.fis_iothub_endpointservicebusqueue_filterjphtarget]
}