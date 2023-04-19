output "avd_vm_public_ips" {
  value       = module.avd_fis.avd_vm_public_ips
}

output "avd_local_admin_passwords" {
    value = module.avd_fis.avd_local_admin_passwords
    sensitive = true
}
