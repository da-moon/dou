
output "accessor" {
  description = "Accessor for OpenLDAP secret engine mount"
  value       = vault_mount.this.accessor
}