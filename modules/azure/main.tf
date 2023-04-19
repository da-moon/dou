
# Create a resource group
resource "azurerm_resource_group" "example" {
  for_each = toset(var.user_emails)
  name     = replace(replace(each.value, "@digitalonus.com", ""), ".", "-")
  location = var.location
  tags = {
    "approver"          = "value"
    "budget"            = "value"
    "client"            = "value"
    "costcenter"        = "value"
    "email"             = "value"
    "environment"       = "value"
    "Leader"            = "value"
    "Members"           = "value"
    "module"            = "value"
    "ms-resource-usage" = "value"
    "owner"             = "value"
    "Project"           = "value"
    "Project Manager"   = "value"
    "role"              = "value"
    "user"              = "value"
  }
}

data "azurerm_subscription" "primary" {
}

data "azuread_user" "example" {
  for_each            = toset(var.user_emails)
  user_principal_name = each.value
}

resource "azurerm_role_assignment" "example" {
  for_each             = toset(var.user_emails)
  scope                = "${data.azurerm_subscription.primary.id}/resourceGroups/${azurerm_resource_group.example[each.key].name}"
  role_definition_name = "Owner"
  principal_id         = data.azuread_user.example[each.key].object_id
}
