# Create Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "${var.prefix}-machine"
  resource_group_name             = data.azurerm_resource_group.terratest_rg.name
  location                        = data.azurerm_resource_group.terratest_rg.location
  disable_password_authentication = false
  size                            = "Standard_DS1_v2"
  admin_username                  = "testadmin"
  admin_password                  = "Password1234!"
  custom_data                     = base64encode(file("files/apache.sh"))
  
  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]

  tags = {
    environment = "qa"
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
}