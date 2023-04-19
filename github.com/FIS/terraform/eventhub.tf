resource "azurerm_eventhub_namespace" "fis_eventhub_ns" {
  name                = "fis-eventhub-ns"
  resource_group_name = azurerm_resource_group.fis_rs.name
  location            = azurerm_resource_group.fis_rs.location
  sku                 = var.eventhub_tier
}

resource "azurerm_eventhub" "fis_digitaltwins_eventub" {
  name                = "fis-digitaltwins-eventub"
  resource_group_name = azurerm_resource_group.fis_rs.name
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  partition_count     = 1
  message_retention   = 7
}

resource "azurerm_eventhub_authorization_rule" "fis_digital_twins_send_rule" {
  name                = "fis-digitaltwins-send-rule"
  resource_group_name = azurerm_resource_group.fis_rs.name
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  eventhub_name       = azurerm_eventhub.fis_digitaltwins_eventub.name
  send                = true
}


resource "azurerm_eventhub_authorization_rule" "fis_digital_twins_listen_rule" {
  name                = "fis-digitaltwins-listen-rule"
  resource_group_name = azurerm_resource_group.fis_rs.name
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  eventhub_name       = azurerm_eventhub.fis_digitaltwins_eventub.name
  listen                = true
}

resource "azurerm_eventhub" "fis_tsi_eventub" {
  name                = "fis-tsi-eventub"
  resource_group_name = azurerm_resource_group.fis_rs.name
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  partition_count     = 1
  message_retention   = 7
}

resource "azurerm_eventhub_consumer_group" "fis_consumer_group" {
  name                = "fis-tsi-consumergroup"
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  eventhub_name       = azurerm_eventhub.fis_tsi_eventub.name
  resource_group_name = azurerm_resource_group.fis_rs.name
}

resource "azurerm_eventhub_authorization_rule" "fis_tsi_send_rule" {
  name                = "fis-tsi-send-rule"
  resource_group_name = azurerm_resource_group.fis_rs.name
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  eventhub_name       = azurerm_eventhub.fis_tsi_eventub.name
  send                = true
}


resource "azurerm_eventhub_authorization_rule" "fis_tsi_listen_rule" {
  name                = "fis-tsi-listen-rule"
  resource_group_name = azurerm_resource_group.fis_rs.name
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  eventhub_name       = azurerm_eventhub.fis_tsi_eventub.name
  listen                = true
}

resource "azurerm_eventhub" "fis_tis_eventub" {
  name                = "fis-tis-eventub"
  resource_group_name = azurerm_resource_group.fis_rs.name
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  partition_count     = 1
  message_retention   = 7
}

resource "azurerm_eventhub_consumer_group" "tis_consumer_group" {
  name                = "tisconsumergroup"
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  eventhub_name       = azurerm_eventhub.fis_tis_eventub.name
  resource_group_name = azurerm_resource_group.fis_rs.name
}

resource "azurerm_eventhub_authorization_rule" "fis_tis_listen_rule" {
  name                = "fis-tis-rule-listen"
  resource_group_name = azurerm_resource_group.fis_rs.name
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  eventhub_name       = azurerm_eventhub.fis_tis_eventub.name
  listen              = true
}

resource "azurerm_eventhub_authorization_rule" "fis_tis_send_rule" {
  name                = "fis-tis-rule-send"
  resource_group_name = azurerm_resource_group.fis_rs.name
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  eventhub_name       = azurerm_eventhub.fis_tis_eventub.name
  send                = true
}

resource "azurerm_digital_twins_endpoint_eventhub" "dt_event_dt" {
  name                                 = "fis-telemetry-adx"
  digital_twins_id                     = azurerm_digital_twins_instance.fis_digital_twins.id
  eventhub_primary_connection_string   = azurerm_eventhub_authorization_rule.fis_digital_twins_send_rule.primary_connection_string
  eventhub_secondary_connection_string = azurerm_eventhub_authorization_rule.fis_digital_twins_send_rule.secondary_connection_string
}
