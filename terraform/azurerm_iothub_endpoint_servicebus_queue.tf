resource "azurerm_iothub_endpoint_servicebus_queue" "fis_iothub_endpointservicebusqueue_filterstatecode" {
  resource_group_name = azurerm_resource_group.fis_rs.name
  iothub_id           = azurerm_iothub.fis_hub.id
  name                = azurerm_eventgrid_system_topic_event_subscription.filter_state_code.name
  connection_string = azurerm_servicebus_queue_authorization_rule.filter_state_code.primary_connection_string
}

resource "azurerm_iothub_endpoint_servicebus_queue" "fis_iothub_endpointservicebusqueue_filterunits" {
  resource_group_name = azurerm_resource_group.fis_rs.name
  iothub_id           = azurerm_iothub.fis_hub.id
  name                = azurerm_eventgrid_system_topic_event_subscription.filter_units.name
  connection_string = azurerm_servicebus_queue_authorization_rule.filter_units.primary_connection_string
}

resource "azurerm_iothub_endpoint_servicebus_queue" "fis_iothub_endpointservicebusqueue_filterjphtarget" {
  resource_group_name = azurerm_resource_group.fis_rs.name
  iothub_id           = azurerm_iothub.fis_hub.id
  name                = azurerm_eventgrid_system_topic_event_subscription.filter_jph.name
  connection_string = azurerm_servicebus_queue_authorization_rule.filter_jph.primary_connection_string
}