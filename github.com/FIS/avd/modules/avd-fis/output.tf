output "avd_vm_public_ips" {
  description = "Public IPs of VM for RDP Client"
  value       = azurerm_windows_virtual_machine.avd.*.public_ip_address
}

output "avd_local_admin_passwords" {
  description = "AVD Local Admin Passwords for RDP Client"
  value       = random_password.avd_local_admin.*.result
  sensitive   = true
}

