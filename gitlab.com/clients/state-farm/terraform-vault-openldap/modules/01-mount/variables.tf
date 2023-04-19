# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 commentstring=#%s expandtab
# code: language=terraform insertSpaces=true tabSize=2

# ╭────────────────────────────────────────────────────────────────────╮
# │                            mount config                            │
# ╰────────────────────────────────────────────────────────────────────╯
variable "mount_point" {
  type        = string
  description = "Mount point of OpenLDAP secret engine"
  default     = "openldap"
}
variable "description" {
  type        = string
  description = "OpenLDAP secret engine description"
  default     = "OpenLDAP secret engine mount"
}
# ╭────────────────────────────────────────────────────────────────────╮
# │                       openldap engine config                       │
# ╰────────────────────────────────────────────────────────────────────╯
variable "binddn" {
  type        = string
  description = <<EOT
  Distinguished name (DN) of object to bind for managing user entries
  EOT
}
# ──────────────────────────────────────────────────────────────────────
variable "bindpass" {
  type        = string
  description = "Password to use along with binddn for managing user entries."
  sensitive   = true
}
# ──────────────────────────────────────────────────────────────────────
variable "url" {
  type        = list(string)
  description = <<EOT
  A list of LDAP servers to connect to.
  EOT
}
# ──────────────────────────────────────────────────────────────────────
variable "password_policy" {
  type        = string
  description = "(Optional) OpenLDAP secret engine password policy name"
  default     = ""
}
variable "password_length" {
  type        = number
  description = "Generated user account password length"
  default     = 14
}
# ──────────────────────────────────────────────────────────────────────
variable "schema" {
  type        = string
  default     = "openldap"
  description = <<EOT
  The OpenLDAP schema to use when storing entry passwords.
  Valid schemas include: `openldap`, `racf` and `ad`.
  EOT
  validation {
    condition     = contains(["openldap", "racf", "ad"], var.schema)
    error_message = "Valid values for 'schema' are (openldap, racf,ad)."
  }
}
# ──────────────────────────────────────────────────────────────────────
variable "request_timeout" {
  type        = number
  default     = 90
  description = <<EOT
  Timeout, in seconds, for the connection when making requests against the
  server before returning back an error.
  EOT
}
# ──────────────────────────────────────────────────────────────────────
variable "starttls" {
  type        = bool
  description = <<EOT
  If true, issues a `StartTLS` command after establishing an unencrypted connection.
  EOT
  default     = true
}
# ──────────────────────────────────────────────────────────────────────
variable "certificate" {
  type        = string
  description = <<EOT
  (Optional) CA certificate to use when verifying LDAP server certificate, must be x509
  PEM encoded.
  EOT
  sensitive   = true
  default     = ""
}
variable "client_tls_cert" {
  type        = string
  description = <<EOT
  (Optional) Client certificate to provide to the LDAP server, must be x509 PEM encoded.
  EOT
  sensitive   = true
  default     = ""
}
variable "client_tls_key" {
  type        = string
  description = <<EOT
  (Optional) Client certificate key to provide to the LDAP server, must be x509 PEM
  encoded.
  EOT
  sensitive   = true
  default     = ""
}
locals {
  url             = join(",", var.url)
  password_policy = length(var.password_policy) > 0 ? var.password_policy : "${var.mount_point}-password-policy"
  insecure_tls    = (length(var.certificate) > 0) && (length(var.client_tls_cert) > 0) && (length(var.client_tls_key) > 0) ? false : true
}