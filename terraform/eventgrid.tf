// Event Grid topic provides an endpoint where the source sends events.
resource "azurerm_eventgrid_topic" "fis_eventgrid_topic" {
  name                = "FIS-EventGrid"
  resource_group_name = azurerm_resource_group.fis_rs.name
  location = azurerm_resource_group.fis_rs.location

  tags = {
    project = "fis"
  }
}

resource "azurerm_storage_queue" "fis_storage_queue" {
  name                 = "fis-storagequeue"
  storage_account_name = azurerm_storage_account.fis_storage_account.name
}

// A subscription tells Event Grid which events on a topic you're interested in receiving
resource "azurerm_eventgrid_event_subscription" "fis_eventgrid_event_subscription" {
  name  = "FIS-EventGrid-Event-Subscription"
  scope = azurerm_resource_group.fis_rs.id

  storage_queue_endpoint {
    storage_account_id = azurerm_storage_account.fis_storage_account.id
    queue_name         = azurerm_storage_queue.fis_storage_queue.name
  }
}

// An event domain is a management tool for large numbers of Event Grid topics related to the same application
resource "azurerm_eventgrid_domain" "fis_eventgrid_domain" {
  name                = "FIS-EventGrid-Domain"
  location            = azurerm_resource_group.fis_rs.location
  resource_group_name = azurerm_resource_group.fis_rs.name

  tags = {
    project = "fis"
  }
}
