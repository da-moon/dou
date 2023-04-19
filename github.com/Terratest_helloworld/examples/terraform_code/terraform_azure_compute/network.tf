# Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.prefix}-PublicIP"
  resource_group_name = data.azurerm_resource_group.terratest_rg.name
  location            = data.azurerm_resource_group.terratest_rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "${var.environment}"
  }
}

# VNets
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.terratest_rg.location
  resource_group_name = data.azurerm_resource_group.terratest_rg.name

  tags = {
    "project" = "assurant"
  }
}

# Subnet
resource "azurerm_subnet" "subnet" { 
  name                      = "${var.prefix}-subnet"
  resource_group_name       = data.azurerm_resource_group.terratest_rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  address_prefixes          = ["10.0.1.0/24"]
}

# Network Interface
resource "azurerm_network_interface" "network_interface" {
  name                = "${var.prefix}-ni"
  location            = data.azurerm_resource_group.terratest_rg.location
  resource_group_name = data.azurerm_resource_group.terratest_rg.name

  ip_configuration {
    name                          = "${var.prefix}-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}