output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "resource_group_name" {
  value = data.azurerm_resource_group.terratest_rg.name
}

output "ip_public_vm" {
  value = azurerm_linux_virtual_machine.vm.public_ip_address
}