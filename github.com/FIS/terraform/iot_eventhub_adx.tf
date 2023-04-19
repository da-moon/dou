# StateCode

resource "azurerm_eventhub" "fis_filter_stateCode" {
  name                = "fis-filter-statecode"
  resource_group_name = azurerm_resource_group.fis_rs.name
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  partition_count     = 1
  message_retention   = 7
}

resource "azurerm_eventhub_authorization_rule" "fis_filter_stateCode_send_rule" {
  name                = "fis-filter-statecode-send-rule"
  resource_group_name = azurerm_resource_group.fis_rs.name
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  eventhub_name       = azurerm_eventhub.fis_filter_stateCode.name
  send                = true
}

resource "azurerm_eventhub_consumer_group" "fis_filter_stateCode_consumer_group" {
  name                = "fis-filter-statecode-consumergroup"
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  eventhub_name       = azurerm_eventhub.fis_filter_stateCode.name
  resource_group_name = azurerm_resource_group.fis_rs.name
}

resource "azurerm_kusto_eventhub_data_connection" "eventhub_connection_filter_stateCode" {
  name                = "fis-filter-statecode-adx-connection"
  resource_group_name = azurerm_resource_group.fis_rs.name
  location            = azurerm_resource_group.fis_rs.location
  cluster_name        = azurerm_kusto_cluster.cluster.name
  database_name       = azurerm_kusto_database.database.name

  eventhub_id    = azurerm_eventhub.fis_filter_stateCode.id
  consumer_group = azurerm_eventhub_consumer_group.fis_filter_stateCode_consumer_group.name

  table_name        = "StateCode"
  mapping_rule_name = "StateCode_Mapping"

  data_format = "JSON"

  depends_on = [
    azurerm_kusto_script.kusto_script_create_table_stateCode_ingestion
  ]
}

# Units

resource "azurerm_eventhub" "fis_filter_units" {
  name                = "fis-filter-units"
  resource_group_name = azurerm_resource_group.fis_rs.name
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  partition_count     = 1
  message_retention   = 7
}

resource "azurerm_eventhub_authorization_rule" "fis_filter_units_send_rule" {
  name                = "fis-filter-units-send-rule"
  resource_group_name = azurerm_resource_group.fis_rs.name
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  eventhub_name       = azurerm_eventhub.fis_filter_units.name
  send                = true
}

resource "azurerm_eventhub_consumer_group" "fis_filter_units_consumer_group" {
  name                = "fis-filter-units-consumergroup"
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  eventhub_name       = azurerm_eventhub.fis_filter_units.name
  resource_group_name = azurerm_resource_group.fis_rs.name
}

resource "azurerm_kusto_eventhub_data_connection" "eventhub_connection_filter_units" {
  name                = "fis-filter-units-adx-connection"
  resource_group_name = azurerm_resource_group.fis_rs.name
  location            = azurerm_resource_group.fis_rs.location
  cluster_name        = azurerm_kusto_cluster.cluster.name
  database_name       = azurerm_kusto_database.database.name

  eventhub_id    = azurerm_eventhub.fis_filter_units.id
  consumer_group = azurerm_eventhub_consumer_group.fis_filter_units_consumer_group.name

  table_name        = "Units"
  mapping_rule_name = "Units_Mapping"

  data_format = "JSON"

  depends_on = [
    azurerm_kusto_script.kusto_script_create_table_units_ingestion
  ]
}

# JPHTarget

resource "azurerm_eventhub" "fis_filter_jph" {
  name                = "fis-filter-jph"
  resource_group_name = azurerm_resource_group.fis_rs.name
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  partition_count     = 1
  message_retention   = 7
}

resource "azurerm_eventhub_authorization_rule" "fis_filter_jph_send_rule" {
  name                = "fis-filter-jph-send-rule"
  resource_group_name = azurerm_resource_group.fis_rs.name
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  eventhub_name       = azurerm_eventhub.fis_filter_jph.name
  send                = true
}

resource "azurerm_eventhub_consumer_group" "fis_filter_jph_consumer_group" {
  name                = "fis-filter-jph-consumergroup"
  namespace_name      = azurerm_eventhub_namespace.fis_eventhub_ns.name
  eventhub_name       = azurerm_eventhub.fis_filter_jph.name
  resource_group_name = azurerm_resource_group.fis_rs.name
}

resource "azurerm_kusto_eventhub_data_connection" "eventhub_connection_filter_jph" {
  name                = "fis-filter-jph-adx-connection"
  resource_group_name = azurerm_resource_group.fis_rs.name
  location            = azurerm_resource_group.fis_rs.location
  cluster_name        = azurerm_kusto_cluster.cluster.name
  database_name       = azurerm_kusto_database.database.name

  eventhub_id    = azurerm_eventhub.fis_filter_jph.id
  consumer_group = azurerm_eventhub_consumer_group.fis_filter_jph_consumer_group.name

  table_name        = "JPH"
  mapping_rule_name = "JPH_Mapping"

  data_format = "JSON"

  depends_on = [
    azurerm_kusto_script.kusto_script_create_table_jph_ingestion
  ]
}

// For ADX 


// StateCode
resource "azurerm_storage_blob" "create_table_stateCode" {
  name                   = "create_table_stateCode.txt"
  storage_account_name   = azurerm_storage_account.fis_storage_account.name
  storage_container_name = azurerm_storage_container.fis_message_container.name
  type                   = "Block"
  source_content         = <<-EOT
      .create table StateCode (Sub_State_Code: double, Event_Code : double, State_Desc : string ,Timestamp: datetime, Device_Alias: string, Sub_State_Desc: string, Event_Desc: string, State_Code : double, Device_ID : double, State_Code_Derived : double, State_Cycling : bool, State_Setup : bool, State_Non_Prod : bool, State_Stopped : bool, State_Breakdown : bool, State_Tooling_Loss : bool, State_Unplanned_Down : bool, State_Net_Available : bool, State_Blocked : bool, Bottleneck_Rank : double, Shared_Bottleneck : double, Sole_Bottleneck : double)
  EOT
}

resource "azurerm_storage_blob" "create_table_stateCode_ingestion" {
  name                   = "create_table_stateCode_ingestion.txt"
  storage_account_name   = azurerm_storage_account.fis_storage_account.name
  storage_container_name = azurerm_storage_container.fis_message_container.name
  type                   = "Block"
  source_content         = <<-EOT
      .create-or-alter table StateCode ingestion json mapping 'StateCode_Mapping' '[{"column":"Sub_State_Code","Properties":{"path":"$.Sub_State_Code"}},{"column":"Event_Code","Properties":{"path":"$.Event_Code"}},{"column":"State_Desc","Properties":{"path":"$.State_Desc"}},{"column":"Timestamp","Properties":{"path":"$.timestamp"}} ,{"column":"Device_Alias","Properties":{"path":"$.Device_Alias"}} ,{"column":"Sub_State_Desc","Properties":{"path":"$.Sub_State_Desc"}} ,{"column":"Event_Desc","Properties":{"path":"$.Event_Desc"}} ,{"column":"State_Code","Properties":{"path":"$.State_Code"}} ,{"column":"Device_ID","Properties":{"path":"$.Device_ID"}}, {"column":"State_Code_Derived","Properties":{"path":"$.State_Code_Derived"}}, {"column":"State_Cycling","Properties":{"path":"$.State_Cycling"}}, {"column":"State_Setup","Properties":{"path":"$.State_Setup"}}, {"column":"State_Non_Prod","Properties":{"path":"$.State_Non_Prod"}}, {"column":"State_Stopped","Properties":{"path":"$.State_Stopped"}}, {"column":"State_Breakdown","Properties":{"path":"$.State_Breakdown"}}, {"column":"State_Tooling_Loss","Properties":{"path":"$.State_Tooling_Loss"}}, {"column":"State_Unplanned_Down","Properties":{"path":"$.State_Unplanned_Down"}}, {"column":"State_Net_Available","Properties":{"path":"$.State_Net_Available"}}, {"column":"State_Blocked","Properties":{"path":"$.State_Blocked"}}, {"column":"Bottleneck_Rank","Properties":{"path":"$.Bottleneck_Rank"}}, {"column":"Shared_Bottleneck","Properties":{"path":"$.Shared_Bottleneck"}}, {"column":"Sole_Bottleneck","Properties":{"path":"$.Sole_Bottleneck"}}]'
  EOT

  depends_on = [
    azurerm_kusto_script.kusto_script_create_table_stateCode
  ]
}

resource "azurerm_kusto_script" "kusto_script_create_table_stateCode" {
  name                               = "kusto_script_create_table_stateCode"
  database_id                        = azurerm_kusto_database.database.id
  url                                = azurerm_storage_blob.create_table_stateCode.id
  sas_token                          = data.azurerm_storage_account_blob_container_sas.storage_account_blob_container_sas.sas
  continue_on_errors_enabled         = false
  force_an_update_when_value_changed = "force2"
}

resource "azurerm_kusto_script" "kusto_script_create_table_stateCode_ingestion" {
  name                               = "kusto_script_create_table_stateCode_ingestion"
  database_id                        = azurerm_kusto_database.database.id
  url                                = azurerm_storage_blob.create_table_stateCode_ingestion.id
  sas_token                          = data.azurerm_storage_account_blob_container_sas.storage_account_blob_container_sas.sas
  continue_on_errors_enabled         = false
  force_an_update_when_value_changed = "force2"
  depends_on = [
    azurerm_kusto_script.kusto_script_create_table_stateCode
  ]
}


// Units
resource "azurerm_storage_blob" "create_table_units" {
  name                   = "create_table_unitsingestion.txt"
  storage_account_name   = azurerm_storage_account.fis_storage_account.name
  storage_container_name = azurerm_storage_container.fis_message_container.name
  type                   = "Block"
  source_content         = <<-EOT
      .create table Units (Units_Total: double, Units_Bad : double ,Timestamp: datetime, Units_Good: double, Device_Alias: string, Device_ID : double)
  EOT
}

resource "azurerm_storage_blob" "create_table_units_ingestion" {
  name                   = "create_table_units_ingestion.txt"
  storage_account_name   = azurerm_storage_account.fis_storage_account.name
  storage_container_name = azurerm_storage_container.fis_message_container.name
  type                   = "Block"
  source_content         = <<-EOT
      .create-or-alter table Units ingestion json mapping 'Units_Mapping' '[{"column":"Units_Total","Properties":{"path":"$.Units_Total"}},{"column":"Units_Bad","Properties":{"path":"$.Units_Bad"}}, {"column":"Timestamp","Properties":{"path":"$.timestamp"}} ,{"column":"Device_Alias","Properties":{"path":"$.Device_Alias"}} ,{"column":"Units_Good","Properties":{"path":"$.Units_Good"}} ,{"column":"Device_ID","Properties":{"path":"$.Device_ID"}}]'
  EOT

  depends_on = [
    azurerm_storage_blob.create_table_units
  ]
}

resource "azurerm_kusto_script" "kusto_script_create_table_units" {
  name                               = "kusto_script_create_table_units"
  database_id                        = azurerm_kusto_database.database.id
  url                                = azurerm_storage_blob.create_table_units.id
  sas_token                          = data.azurerm_storage_account_blob_container_sas.storage_account_blob_container_sas.sas
  continue_on_errors_enabled         = false
  force_an_update_when_value_changed = "force"
}

resource "azurerm_kusto_script" "kusto_script_create_table_units_ingestion" {
  name                               = "kusto_script_create_table_units_ingestion"
  database_id                        = azurerm_kusto_database.database.id
  url                                = azurerm_storage_blob.create_table_units_ingestion.id
  sas_token                          = data.azurerm_storage_account_blob_container_sas.storage_account_blob_container_sas.sas
  continue_on_errors_enabled         = false
  force_an_update_when_value_changed = "force"
  depends_on = [
    azurerm_kusto_script.kusto_script_create_table_units
  ]
}


// JPH
resource "azurerm_storage_blob" "create_table_jph" {
  name                   = "create_table_jphingestion.txt"
  storage_account_name   = azurerm_storage_account.fis_storage_account.name
  storage_container_name = azurerm_storage_container.fis_message_container.name
  type                   = "Block"
  source_content         = <<-EOT
      .create table JPH (JPH_Target: double, Schedule_Is_Productive : double, Cycletime_Design_Target : double ,Timestamp: datetime, Device_Alias: string, Cycletime_Unscaled_Value: double, Cycletime_Invalid_Target: double, Device_ID : double, Cycletime_Value : double, Cycletime_Overtime_Value : double, Cycletime_Slow : bool, Cycletime_Invalid : bool)
  EOT
}

resource "azurerm_storage_blob" "create_table_jph_ingestion" {
  name                   = "create_table_jph_ingestion.txt"
  storage_account_name   = azurerm_storage_account.fis_storage_account.name
  storage_container_name = azurerm_storage_container.fis_message_container.name
  type                   = "Block"
  source_content         = <<-EOT
      .create-or-alter table JPH ingestion json mapping 'JPH_Mapping' '[{"column":"JPH_Target","Properties":{"path":"$.JPH_Target"}},{"column":"Schedule_Is_Productive","Properties":{"path":"$.Schedule_Is_Productive"}},{"column":"Cycletime_Design_Target","Properties":{"path":"$.Cycletime_Design_Target"}},{"column":"Timestamp","Properties":{"path":"$.timestamp"}} ,{"column":"Device_Alias","Properties":{"path":"$.Device_Alias"}} ,{"column":"Cycletime_Unscaled_Value","Properties":{"path":"$.Cycletime_Unscaled_Value"}} ,{"column":"Cycletime_Invalid_Target","Properties":{"path":"$.Cycletime_Invalid_Target"}} ,{"column":"Device_ID","Properties":{"path":"$.Device_ID"}}, {"column":"Cycletime_Overtime_Value","Properties":{"path":"$.Cycletime_Overtime_Value"}}, {"column":"Cycletime_Slow","Properties":{"path":"$.Cycletime_Slow"}}, {"column":"Cycletime_Invalid","Properties":{"path":"$.Cycletime_Invalid"}}, {"column":"Cycletime_Value","Properties":{"path":"$.Cycletime_Value"}}]'
  EOT

  depends_on = [
    azurerm_storage_blob.create_table_jph
  ]
}

resource "azurerm_kusto_script" "kusto_script_create_table_jph" {
  name                               = "kusto_script_create_table_jph"
  database_id                        = azurerm_kusto_database.database.id
  url                                = azurerm_storage_blob.create_table_jph.id
  sas_token                          = data.azurerm_storage_account_blob_container_sas.storage_account_blob_container_sas.sas
  continue_on_errors_enabled         = false
  force_an_update_when_value_changed = "force"
}

resource "azurerm_kusto_script" "kusto_script_create_table_jph_ingestion" {
  name                               = "kusto_script_create_table_jph_ingestion"
  database_id                        = azurerm_kusto_database.database.id
  url                                = azurerm_storage_blob.create_table_jph_ingestion.id
  sas_token                          = data.azurerm_storage_account_blob_container_sas.storage_account_blob_container_sas.sas
  continue_on_errors_enabled         = false
  force_an_update_when_value_changed = "force"

  depends_on = [
    azurerm_kusto_script.kusto_script_create_table_jph
  ]
}
