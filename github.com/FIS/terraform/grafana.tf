resource "grafana_data_source" "adx" {
  type = "grafana-azure-data-explorer-datasource"
  name = "azure-adx-datasource"

  uid = "HYppU6unz" # Needs to be same as in json dashboards, otherwise it won't reflect the data from adx
  
  is_default = true

  json_data_encoded = jsonencode({
    "clientId"        = "${var.az_service_principal}"
    "clusterUrl"      = "${azurerm_kusto_cluster.cluster.uri}"
    "tenantId"        = "${var.tenant_id}"
    "defaultDatabase" = "${azurerm_kusto_database.database.name}"
  })
  secure_json_data_encoded = jsonencode({
    "clientSecret" = "${var.az_client_secret}"
  })
}

resource "grafana_dashboard" "metrics" {
  for_each = fileset(path.module, "grafana_dashboards/*.json")

  config_json = file("${path.module}/${each.key}")

  depends_on = [
    grafana_data_source.adx
  ]
}
