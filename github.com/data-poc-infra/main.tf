data "azurerm_resource_group" "rg" {
  name = "data-poc"
}

resource "azurerm_cognitive_account" "cognitive" {
  name                = "techmpoc-cognitive"
  kind                = "CognitiveServices"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku_name            = "S0"
}

resource "azurerm_storage_account" "account" {
  name                     = "techmpocaccount"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "lake" {
  name               = "techmpoclake"
  storage_account_id = azurerm_storage_account.account.id
}

resource "azurerm_data_factory" "factory" {
  name                = "techmpoc-data-factory"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_data_factory_pipeline" "pipeline" {
  name            = "techmpoc-pipeline"
  data_factory_id = azurerm_data_factory.factory.id
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "techmpoc-cosmos-db-account"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  enable_automatic_failover = false

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = "eastus"
    failover_priority = 0
  }

  backup {
    type                = "Periodic"
    interval_in_minutes = 1440
    retention_in_hours  = 8
  }
}
