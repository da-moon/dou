# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 commentstring=#%s expandtab
# code: language=terraform insertSpaces=true tabSize=2

# ╭────────────────────────────────────────────────────────────────────╮
# │                         main secret source                         │
# ╰────────────────────────────────────────────────────────────────────╯
#
# ─── NOTE ───────────────────────────────────────────────────────────────────────
# this module is used for retrieval of secrets from Vault
module "vault_kv_read" {
  source     = "./modules/vault-kv-read/"
  entry_path = var.vault_data_path
}
# ╭────────────────────────────────────────────────────────────────────╮
# │                        certificate fallback                        │
# ╰────────────────────────────────────────────────────────────────────╯
data "local_file" "ldap_client_ca_certificate" {
  count    = length(var.ldap_client_ca_certificate_path) > 0 ? 1 : 0
  filename = var.ldap_client_ca_certificate_path
}
data "local_file" "ldap_client_tls_cert" {
  count    = length(var.ldap_client_tls_cert_path) > 0 ? 1 : 0
  filename = var.ldap_client_tls_cert_path
}
data "local_file" "ldap_client_tls_key" {
  count    = length(var.ldap_client_tls_key_path) > 0 ? 1 : 0
  filename = var.ldap_client_tls_key_path
}
# ─── NOTE ───────────────────────────────────────────────────────────────────────
# this module mount OpenLDAP secret engine and configures it.
# ─── SNIPPETS ───────────────────────────────────────────────────────────────────
# Get a list of enabled secret engines
#
# vault secrets list
# ────────────────────────────────────────────────────────────────────────────────
# Get configuration of OpenLDAP secret Engine
#
# vault read /openldap/config
# ────────────────────────────────────────────────────────────────────────────────
module "mount-and-configure" {
  source = "./modules/01-mount/"
  providers = {
    vault = vault
  }
  mount_point     = var.mount_point
  description     = var.mount_description
  binddn          = local.ldap_server_binddn
  bindpass        = local.ldap_server_bindpass
  url             = var.ldap_server_url
  password_policy = var.ldap_password_policy
  password_length = var.ldap_password_length
  schema          = var.ldap_server_schema
  request_timeout = var.ldap_server_request_timeout
  starttls        = var.ldap_starttls
  certificate     = local.ldap_client_ca_certificate
  client_tls_cert = local.ldap_client_tls_cert
  client_tls_key  = local.ldap_client_tls_key
}
# ─── NOTE ───────────────────────────────────────────────────────────────────────
# This module adds a role for dynamic generation of credentials.
# ─── SNIPPETS ───────────────────────────────────────────────────────────────────
# List roles
#
# vault list openldap/role
# ────────────────────────────────────────────────────────────────────────────────
# Create a new user
#
# vault read -format=json openldap/creds/openldap-dynamic-role | jq -r 
# ────────────────────────────────────────────────────────────────────────────────
# ensure user can login 
# 
# ldapwhoami -vvv -H "ldap://${LDAP_ADDR}" -D "${distinguished_names}" -x -w "${password}"
module "dynamic-credentials" {
  source = "./modules/02-dynamic-credentials/"
  depends_on = [
    module.mount-and-configure
  ]
  providers = {
    vault = vault
  }
  mount_point       = var.mount_point
  role_name         = var.dynamic_credentials_role_name
  username_template = var.dynamic_credentials_role_username_template
  default_ttl       = var.dynamic_credentials_role_default_ttl
  max_ttl           = var.dynamic_credentials_role_max_ttl
}