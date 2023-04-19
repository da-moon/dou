resource "azurerm_resource_group" "example" {
  name     = "example"
  location = "West Europe"

  tags = {
    "environment" = "test"
    "budget"      = "$100,000 USD"

  }
}
