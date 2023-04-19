# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 commentstring=#%s expandtab
# code: language=terraform insertSpaces=true tabSize=2

# common
variable "mount_point" {
  type        = string
  description = "Mount point of OpenLDAP secret engine"
  default     = "openldap"
}
# ╭────────────────────────────────────────────────────────────────────╮
# │                              01-mount                              │
# ╰────────────────────────────────────────────────────────────────────╯
variable "mount_description" {
  type        = string
  description = "OpenLDAP secret engine description"
  default     = "OpenLDAP secret engine mount"
}
variable "ldap_password_policy" {
  type        = string
  description = "(Optional) OpenLDAP secret engine password policy name"
  default     = ""
}
variable "ldap_password_length" {
  type        = number
  description = "Generated user account password length"
  default     = 14
}
# # ──────────────────────────────────────────────────────────────────────
variable "ldap_server_binddn" {
  type        = string
  description = <<EOT
  Distinguished name (DN) of object to bind for managing user entries
  EOT
  default     = ""
}
# ──────────────────────────────────────────────────────────────────────
variable "ldap_server_bindpass" {
  type        = string
  description = "Password to use along with binddn for managing user entries."
  sensitive   = true
  default     = ""
}
# # ──────────────────────────────────────────────────────────────────────
variable "ldap_server_url" {
  type        = list(string)
  description = <<EOT
  A list of LDAP servers to connect to.
  EOT
}
# # ──────────────────────────────────────────────────────────────────────
variable "ldap_server_schema" {
  type        = string
  default     = "openldap"
  description = <<EOT
  The OpenLDAP schema to use when storing entry passwords.
  Valid schemas include: `openldap`, `racf` and `ad`.
  EOT
  validation {
    condition     = contains(["openldap", "racf", "ad"], var.ldap_server_schema)
    error_message = "Valid values for 'schema' are (openldap, racf,ad)."
  }
}
# ──────────────────────────────────────────────────────────────────────
variable "ldap_server_request_timeout" {
  type        = number
  default     = 90
  description = <<EOT
  Timeout, in seconds, for the connection when making requests against the
  server before returning back an error.
  EOT
}
# ──────────────────────────────────────────────────────────────────────
variable "ldap_starttls" {
  type        = bool
  description = <<EOT
  If true, issues a `StartTLS` command after establishing an unencrypted connection.
  EOT
  default     = true
}
# # ──────────────────────────────────────────────────────────────────────
variable "vault_data_path" {
  type        = string
  description = <<EOT
  Path of an entry in vault KV store that stores LDAP server's
  `binddn` , `bindpass` , `certificate` , `client_tls_cert`, `client_tls_key`
  EOT
  default     = ""
}
variable "ldap_client_ca_certificate_path" {
  type        = string
  description = <<EOT
  (Optional) Path of a CA certificate file to use when verifying LDAP server
  certificate, must be x509 PEM encoded.
  EOT
  default     = ""
}
variable "ldap_client_tls_cert_path" {
  type        = string
  description = <<EOT
  (Optional) Path of client certificate to provide to the LDAP server, must be
  x509 PEM encoded.
  EOT
  default     = ""
}
variable "ldap_client_tls_key_path" {
  type        = string
  description = <<EOT
  (Optional) Path of client certificate key to provide to the LDAP server, must
  be x509 PEM encoded.
  EOT
  sensitive   = true
  default     = ""
}
variable "dynamic_credentials_role_name" {
  type        = string
  default     = ""
  description = <<EOT
  (optional) The name of the dynamic role. 

  In case it is not provided, it will default to '<mount_point>-dynamic-role'.
  EOT
}
variable "dynamic_credentials_role_username_template" {
  type        = string
  default     = "v_{{.DisplayName}}_{{.RoleName}}_{{random 10}}_{{unix_time}}"
  description = <<EOT
  A template used to generate a dynamic username. 

  This will be used to fill in th `.Username` field within the `creation_ldif`
  string.
  EOT
}
variable "dynamic_credentials_role_default_ttl" {
  type        = string
  default     = "1h"
  description = <<EOT
  Specifies the TTL for the leases associated with this role. 
  Accepts time suffixed strings ("1h") or an integer number of seconds. 

  Defaults to system/engine default TTL time. 
  
  The available units are: ns, us (or µs), ms, s, m, h.
  EOT
}
variable "dynamic_credentials_role_max_ttl" {
  type        = string
  default     = "24h"
  description = <<EOT
  Specifies the maximum TTL for the leases associated with this role. 
  Accepts time suffixed strings ("1h") or an integer number of seconds. 
  
  Defaults to system/mount default TTL time.
  this value is allowed to be less than the mount max TTL 
  (or, if not set, the system max TTL), but it is not allowed to be longer.
  
  The available units are: ns, us (or µs), ms, s, m, h.
  EOT
}
locals {
  ldap_server_binddn = (
    length(var.ldap_server_binddn) > 0 ?
    var.ldap_server_binddn :
    module.vault_kv_read.binddn
  )
  ldap_server_bindpass = (
    length(var.ldap_server_bindpass) > 0 ?
    var.ldap_server_bindpass :
    module.vault_kv_read.bindpass
  )
  # ldap_client_ca_certificate = can(data.local_file.ldap_client_ca_certificate[0]) ? data.local_file.ldap_client_ca_certificate[0].content : ""
  ldap_client_ca_certificate = (
    length(module.vault_kv_read.certificate) > 0 ?
    module.vault_kv_read.certificate :
    (
      can(data.local_file.ldap_client_ca_certificate[0]) ?
      data.local_file.ldap_client_ca_certificate[0].content :
      ""
    )
  )
  # ldap_client_tls_cert = can(data.local_file.ldap_client_tls_cert[0]) ? data.local_file.ldap_client_tls_cert[0].content : ""
  ldap_client_tls_cert = (
    length(module.vault_kv_read.client_tls_cert) > 0 ?
    module.vault_kv_read.client_tls_cert :
    (
      can(data.local_file.ldap_client_tls_cert[0]) ?
      data.local_file.ldap_client_tls_cert[0].content :
      ""
    )
  )
  # ldap_client_tls_key  = can(data.local_file.ldap_client_tls_key[0]) ? data.local_file.ldap_client_tls_key[0].content : ""
  ldap_client_tls_key = (
    length(module.vault_kv_read.client_tls_key) > 0 ?
    module.vault_kv_read.client_tls_key :
    (
      can(data.local_file.ldap_client_tls_key[0]) ?
      data.local_file.ldap_client_tls_key[0].content :
      ""
    )
  )
}
