# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 commentstring=#%s expandtab
# code: language=terraform insertSpaces=true tabSize=2

output "binddn" {
  description = "OpenLDAP client binddn"
  value       = local.binddn
  sensitive   = true
}
output "bindpass" {
  description = "OpenLDAP client bindpass"
  value       = local.bindpass
  sensitive   = true
}
output "certificate" {
  description = "OpenLDAP client certificate"
  value       = local.certificate
  sensitive   = true
}
output "client_tls_cert" {
  description = "OpenLDAP client client TLS cert"
  value       = local.client_tls_cert
  sensitive   = true
}
output "client_tls_key" {
  sensitive   = true
  value       = local.client_tls_key
  description = "OpenLDAP client client TLS key"
}