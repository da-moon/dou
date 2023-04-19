resource "azurerm_iothub_endpoint_storage_container" "fis_iothub_endpointcontainer_filterjphtarget" {
  resource_group_name = azurerm_resource_group.fis_rs.name
  iothub_id           = azurerm_iothub.fis_hub.id
  name                = "FIS-FilterJPHTarget-StorageContainer"
  container_name    = azurerm_storage_container.fis_FilterJPHTarget_container.name
  connection_string = azurerm_storage_account.fis_storage_account.primary_blob_connection_string
  file_name_format           = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
  batch_frequency_in_seconds = 60
  max_chunk_size_in_bytes    = 10485760
  encoding                   = "JSON"
}

resource "azurerm_iothub_endpoint_storage_container" "fis_iothub_endpointcontainer_filterunits" {
  resource_group_name = azurerm_resource_group.fis_rs.name
  iothub_id           = azurerm_iothub.fis_hub.id
  name                = "FIS-FilterUnits-StorageContainer"
  container_name    = azurerm_storage_container.fis_FilterUnits_container.name
  connection_string = azurerm_storage_account.fis_storage_account.primary_blob_connection_string
  file_name_format           = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
  batch_frequency_in_seconds = 60
  max_chunk_size_in_bytes    = 10485760
  encoding                   = "JSON"
}

resource "azurerm_iothub_endpoint_storage_container" "fis_iothub_endpointcontainer_filterstatecode" {
  resource_group_name = azurerm_resource_group.fis_rs.name
  iothub_id           = azurerm_iothub.fis_hub.id
  name                = "FIS-FilterStateCode-StorageContainer"
  container_name    = azurerm_storage_container.fis_FilterStateCode_container.name
  connection_string = azurerm_storage_account.fis_storage_account.primary_blob_connection_string
  file_name_format           = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
  batch_frequency_in_seconds = 60
  max_chunk_size_in_bytes    = 10485760
  encoding                   = "JSON"
}