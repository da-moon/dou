output "consul_fqdn" {
  value = "consul.${local.domain}"
}
output "vault_fqdn" {
  value = "vault.${local.domain}"
}
output "proxy_credentials" {
  value = {
    user: var.proxy_user,
    password: local.proxy_pass
  } 
}