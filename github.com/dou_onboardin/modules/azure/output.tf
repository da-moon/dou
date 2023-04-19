output "azure_user_id" {
  value = values(data.azuread_user.example)[*].object_id
}

output "azure_resource_group_name" {
  value = values(azurerm_resource_group.example)[*].name
}

output "azure_resource_group_region" {
  value = values(azurerm_resource_group.example)[*].location
}