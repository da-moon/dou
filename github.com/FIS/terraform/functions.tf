resource "azurerm_service_plan" "fis_functions_service_plan" {
  name                = "fis-functions-service-plan"
  location            = azurerm_resource_group.fis_rs.location
  resource_group_name = azurerm_resource_group.fis_rs.name

  os_type  = "Linux"
  sku_name = "B2"
}

resource "azurerm_linux_function_app" "fis_data_save" {
  name                = "fis-data-save"
  resource_group_name = azurerm_resource_group.fis_rs.name
  location            = azurerm_resource_group.fis_rs.location

  storage_account_name       = azurerm_storage_account.fis_storage_account.name
  storage_account_access_key = azurerm_storage_account.fis_storage_account.primary_access_key

  service_plan_id = azurerm_service_plan.fis_functions_service_plan.id

  site_config {
    application_stack {
      python_version = "3.8"
    }
    application_insights_connection_string = azurerm_application_insights.fis_app_insights.connection_string
    application_insights_key               = azurerm_application_insights.fis_app_insights.instrumentation_key
  }

  app_settings = {
    "BUILD_FLAGS"                    = "UseExpressBuild"
    "ENABLE_ORYX_BUILD"              = "true"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "1"
    "XDG_CACHE_HOME"                 = "/tmp/.cache"
    "AZURE_ADT_URL"                  = format("https://%s", azurerm_digital_twins_instance.fis_digital_twins.host_name)
    "AZURE_TENANT_ID"                = data.azurerm_client_config.current.tenant_id
    "AZURE_CLIENT_ID"                = var.az_service_principal
    "AZURE_CLIENT_SECRET"            = var.az_client_secret
    WEBSITE_RUN_FROM_PACKAGE         = 1
  }

  identity {
    identity_ids = []
    type         = "SystemAssigned"
  }
}

resource "azurerm_linux_function_app" "fis_telemetry_adx" {
  name                = "fis-telemetry-adx"
  resource_group_name = azurerm_resource_group.fis_rs.name
  location            = azurerm_resource_group.fis_rs.location

  storage_account_name       = azurerm_storage_account.fis_storage_account.name
  storage_account_access_key = azurerm_storage_account.fis_storage_account.primary_access_key

  service_plan_id = azurerm_service_plan.fis_functions_service_plan.id

  site_config {
    application_stack {
      python_version = "3.8"
    }
    application_insights_connection_string = azurerm_application_insights.fis_app_insights.connection_string
    application_insights_key               = azurerm_application_insights.fis_app_insights.instrumentation_key
  }

  app_settings = {
    "BUILD_FLAGS"                                      = "UseExpressBuild"
    "ENABLE_ORYX_BUILD"                                = "true"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"                   = "1"
    "XDG_CACHE_HOME"                                   = "/tmp/.cache"
    "fiseventhubns_fisdigitaltwinslistenrule_EVENTHUB" = azurerm_eventhub_authorization_rule.fis_digital_twins_listen_rule.primary_connection_string
    "ADX_CONNECTION_STRING_STATE_CODE"                 = azurerm_eventhub_authorization_rule.fis_filter_stateCode_send_rule.primary_connection_string
    "ADX_CONNECTION_STRING_JPH"                        = azurerm_eventhub_authorization_rule.fis_filter_jph_send_rule.primary_connection_string
    "ADX_CONNECTION_STRING_UNITS"                      = azurerm_eventhub_authorization_rule.fis_filter_units_send_rule.primary_connection_string
  }

  identity {
    identity_ids = []
    type         = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "data_save_role" {
  scope                = azurerm_resource_group.fis_rs.id
  principal_id         = azurerm_linux_function_app.fis_data_save.identity.0.principal_id
  role_definition_name = "Azure Digital Twins Data Owner"

  depends_on = [
    azurerm_linux_function_app.fis_data_save
  ]
}
