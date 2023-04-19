terraform {
  required_version = ">= 0.13.3"
}

provider "azurerm" {

  features {}
  version = "=2.28.0"
  skip_provider_registration  = true
}

data "azurerm_resource_group" "main" {
  name = var.rg_name
}


resource "azurerm_virtual_network" "az_vn" {
  name                = "${var.prefix}-virtualnetwork"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_subnet" "az_sn" {
  name                 = "${var.prefix}-internalsubnet"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.az_vn.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "az_pip" {
  name                    = "${var.prefix}-publicip"
  location                = data.azurerm_resource_group.main.location
  resource_group_name     = data.azurerm_resource_group.main.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
}


resource "azurerm_network_interface" "az_ni" {
  name                = "${var.prefix}-networkinterface"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.az_sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.az_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "az_vm" {
  name                = "${var.prefix}-virtualmachine"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.az_ni.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  
  tags = {
    project = "assurant"
    team = "terratest"
    hotel = "trivago"
  }
}