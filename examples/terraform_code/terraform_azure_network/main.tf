provider "azurerm" {
  version = "2.27.0"
  features {}
}

data "azurerm_resource_group" "terratest_rg" {
  name     = "${var.resource_group_terratest}"
}