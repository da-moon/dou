resource "azurerm_servicebus_namespace" "filter_messages" {
  name                = "fis-servicebus-namespace"
  location            = azurerm_resource_group.fis_rs.location
  resource_group_name = azurerm_resource_group.fis_rs.name
  sku                 = "Premium"
  capacity            = 1
}

resource "azurerm_eventgrid_system_topic" "filter_messages" {
  name                   = "filterMessages"
  resource_group_name    = azurerm_resource_group.fis_rs.name
  location               = azurerm_resource_group.fis_rs.location
  source_arm_resource_id = azurerm_servicebus_namespace.filter_messages.id
  topic_type             = "Microsoft.ServiceBus.Namespaces"

}

resource "azurerm_service_plan" "functions_filter" {
  name                = "fis-functions-filter"
  location            = azurerm_resource_group.fis_rs.location
  resource_group_name = azurerm_resource_group.fis_rs.name

  os_type  = "Linux"
  sku_name = "EP1"
}

// For different types of messages

// FilterStateCode
resource "azurerm_servicebus_queue" "filter_state_code" {
  name         = "filter-StateCode"
  namespace_id = azurerm_servicebus_namespace.filter_messages.id
}

resource "azurerm_servicebus_queue_authorization_rule" "filter_state_code" {
  name     = azurerm_servicebus_queue.filter_state_code.name
  queue_id = azurerm_servicebus_queue.filter_state_code.id

  send = true
}

// In order to create a Topic Event subscription, must re-apply after the code is deployed to a function app
resource "azurerm_eventgrid_system_topic_event_subscription" "filter_state_code" {
  name                = azurerm_servicebus_queue.filter_state_code.name
  system_topic        = azurerm_eventgrid_system_topic.filter_messages.name
  resource_group_name = azurerm_resource_group.fis_rs.name

  azure_function_endpoint {
    function_id                       = format("%s/functions/%s", azurerm_linux_function_app.filter_state_code.id, azurerm_linux_function_app.filter_state_code.name)
    max_events_per_batch              = 1
    preferred_batch_size_in_kilobytes = 64
  }

  advanced_filtering_on_arrays_enabled = true

  included_event_types = ["Microsoft.ServiceBus.ActiveMessagesAvailableWithNoListeners",
  "Microsoft.ServiceBus.DeadletterMessagesAvailableWithNoListeners"]

  event_delivery_schema = "EventGridSchema"
}

// FilterUnits
resource "azurerm_servicebus_queue" "filter_units" {
  name         = "filter-Units"
  namespace_id = azurerm_servicebus_namespace.filter_messages.id
}

resource "azurerm_servicebus_queue_authorization_rule" "filter_units" {
  name     = azurerm_servicebus_queue.filter_units.name
  queue_id = azurerm_servicebus_queue.filter_units.id

  send = true
}

// In order to create a Topic Event subscription, must re-apply after the code is deployed to a function app
resource "azurerm_eventgrid_system_topic_event_subscription" "filter_units" {
  name                = azurerm_servicebus_queue.filter_units.name
  system_topic        = azurerm_eventgrid_system_topic.filter_messages.name
  resource_group_name = azurerm_resource_group.fis_rs.name

  azure_function_endpoint {
    function_id                       = format("%s/functions/%s", azurerm_linux_function_app.filter_units.id, azurerm_linux_function_app.filter_units.name)
    max_events_per_batch              = 1
    preferred_batch_size_in_kilobytes = 64
  }

  advanced_filtering_on_arrays_enabled = true

  included_event_types = ["Microsoft.ServiceBus.ActiveMessagesAvailableWithNoListeners",
  "Microsoft.ServiceBus.DeadletterMessagesAvailableWithNoListeners"]

  event_delivery_schema = "EventGridSchema"
}

// FilterJPH
resource "azurerm_servicebus_queue" "filter_jph" {
  name         = "filter-JPHTarget"
  namespace_id = azurerm_servicebus_namespace.filter_messages.id
}

resource "azurerm_servicebus_queue_authorization_rule" "filter_jph" {
  name     = azurerm_servicebus_queue.filter_jph.name
  queue_id = azurerm_servicebus_queue.filter_jph.id

  send = true
}

// In order to create a Topic Event subscription, must re-apply after the code is deployed to a function app
resource "azurerm_eventgrid_system_topic_event_subscription" "filter_jph" {
  name                = azurerm_servicebus_queue.filter_jph.name
  system_topic        = azurerm_eventgrid_system_topic.filter_messages.name
  resource_group_name = azurerm_resource_group.fis_rs.name

  azure_function_endpoint {
    function_id                       = format("%s/functions/%s", azurerm_linux_function_app.filter_jph.id, azurerm_linux_function_app.filter_jph.name)
    max_events_per_batch              = 1
    preferred_batch_size_in_kilobytes = 64
  }

  advanced_filtering_on_arrays_enabled = true

  included_event_types = ["Microsoft.ServiceBus.ActiveMessagesAvailableWithNoListeners",
  "Microsoft.ServiceBus.DeadletterMessagesAvailableWithNoListeners"]

  event_delivery_schema = "EventGridSchema"
}

// Functions for different type of messages

// FilterStateCode
resource "azurerm_linux_function_app" "filter_state_code" {
  name                = "fis-filterStateCode"
  resource_group_name = azurerm_resource_group.fis_rs.name
  location            = azurerm_resource_group.fis_rs.location

  service_plan_id = azurerm_service_plan.functions_filter.id

  storage_account_name       = azurerm_storage_account.fis_storage_account.name
  storage_account_access_key = azurerm_storage_account.fis_storage_account.primary_access_key

  site_config {
    application_stack {
      python_version = "3.9"
    }
    application_insights_connection_string = azurerm_application_insights.fis_app_insights.connection_string
    application_insights_key               = azurerm_application_insights.fis_app_insights.instrumentation_key
  }

  app_settings = {
    "BUILD_FLAGS"                         = "UseExpressBuild"
    "ENABLE_ORYX_BUILD"                   = "true"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"      = "1"
    "XDG_CACHE_HOME"                      = "/tmp/.cache"
    "AZURE_ADT_URL"                       = format("https://%s", azurerm_digital_twins_instance.fis_digital_twins.host_name)
    "AZURE_TENANT_ID"                     = data.azurerm_client_config.current.tenant_id
    "AZURE_CLIENT_ID"                     = var.az_service_principal
    "AZURE_CLIENT_SECRET"                 = var.az_client_secret
    "AZURE_SERVICE_BUS_CONNECTION_STRING" = azurerm_servicebus_namespace.filter_messages.default_primary_connection_string
    "AZURE_SERVICE_BUS_QUEUE_NAME"        = azurerm_servicebus_queue.filter_state_code.name
    "WEBSITE_RUN_FROM_PACKAGE"            = 1
  }

  identity {
    identity_ids = []
    type         = "SystemAssigned"
  }
}

// Filter Units
resource "azurerm_linux_function_app" "filter_units" {
  name                = "fis-filterUnits"
  resource_group_name = azurerm_resource_group.fis_rs.name
  location            = azurerm_resource_group.fis_rs.location

  service_plan_id = azurerm_service_plan.functions_filter.id

  storage_account_name       = azurerm_storage_account.fis_storage_account.name
  storage_account_access_key = azurerm_storage_account.fis_storage_account.primary_access_key

  site_config {
    application_stack {
      python_version = "3.9"
    }
    application_insights_connection_string = azurerm_application_insights.fis_app_insights.connection_string
    application_insights_key               = azurerm_application_insights.fis_app_insights.instrumentation_key
  }

  app_settings = {
    "BUILD_FLAGS"                         = "UseExpressBuild"
    "ENABLE_ORYX_BUILD"                   = "true"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"      = "1"
    "XDG_CACHE_HOME"                      = "/tmp/.cache"
    "AZURE_ADT_URL"                       = format("https://%s", azurerm_digital_twins_instance.fis_digital_twins.host_name)
    "AZURE_TENANT_ID"                     = data.azurerm_client_config.current.tenant_id
    "AZURE_CLIENT_ID"                     = var.az_service_principal
    "AZURE_CLIENT_SECRET"                 = var.az_client_secret
    "AZURE_SERVICE_BUS_CONNECTION_STRING" = azurerm_servicebus_namespace.filter_messages.default_primary_connection_string
    "AZURE_SERVICE_BUS_QUEUE_NAME"        = azurerm_servicebus_queue.filter_units.name
    "WEBSITE_RUN_FROM_PACKAGE"            = 1
  }

  identity {
    identity_ids = []
    type         = "SystemAssigned"
  }
}

// FilterJPH
resource "azurerm_linux_function_app" "filter_jph" {
  name                = "fis-filterJPHTarget"
  resource_group_name = azurerm_resource_group.fis_rs.name
  location            = azurerm_resource_group.fis_rs.location

  service_plan_id = azurerm_service_plan.functions_filter.id

  storage_account_name       = azurerm_storage_account.fis_storage_account.name
  storage_account_access_key = azurerm_storage_account.fis_storage_account.primary_access_key

  site_config {
    application_stack {
      python_version = "3.9"
    }
    application_insights_connection_string = azurerm_application_insights.fis_app_insights.connection_string
    application_insights_key               = azurerm_application_insights.fis_app_insights.instrumentation_key
  }

  app_settings = {
    "BUILD_FLAGS"                         = "UseExpressBuild"
    "ENABLE_ORYX_BUILD"                   = "true"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"      = "1"
    "XDG_CACHE_HOME"                      = "/tmp/.cache"
    "AZURE_ADT_URL"                       = format("https://%s", azurerm_digital_twins_instance.fis_digital_twins.host_name)
    "AZURE_TENANT_ID"                     = data.azurerm_client_config.current.tenant_id
    "AZURE_CLIENT_ID"                     = var.az_service_principal
    "AZURE_CLIENT_SECRET"                 = var.az_client_secret
    "AZURE_SERVICE_BUS_CONNECTION_STRING" = azurerm_servicebus_namespace.filter_messages.default_primary_connection_string
    "AZURE_SERVICE_BUS_QUEUE_NAME"        = azurerm_servicebus_queue.filter_jph.name
    "WEBSITE_RUN_FROM_PACKAGE"            = 1
  }

  identity {
    identity_ids = []
    type         = "SystemAssigned"
  }
}
