# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 commentstring=#%s expandtab
# code: language=terraform insertSpaces=true tabSize=2
variable "mount_point" {
  type        = string
  default     = "openldap"
  description = "Mount point of OpenLDAP secret engine"
}
variable "role_name" {
  type        = string
  default     = ""
  description = <<EOT
  (optional) The name of the dynamic role. 

  In case it is not provided, it will default to '<mount_point>-dynamic-role'.
  EOT
}
variable "creation_ldif_path" {
  type        = string
  default     = "files/creation.ldif"
  description = <<EOT
  Relative path from module's root to a templatized LDIF string used to create
  a user account. This may contain multiple LDIF entries. The `creation_ldif`
  can also be used to add the user account to an existing group. All LDIF
  entries are performed in order. If Vault encounters an error while executing
  the `creation_ldif` it will stop at the first error and not execute any
  remaining LDIF entries. If an error occurs and `rollback_ldif` is specified,
  the LDIF entries in `rollback_ldif` will be executed. See `rollback_ldif` for
  more details. This field may optionally be provided as a base64 encoded
  string.
  EOT
}
variable "deletion_ldif_path" {
  type        = string
  default     = "files/deletion.ldif"
  description = <<EOT
  Relative path from module's root to a templatized LDIF string used to delete
  the user account once its TTL has expired. This may contain multiple LDIF
  entries. All LDIF entries are performed in order. If Vault encounters an
  error while executing an entry in the `deletion_ldif` it will attempt to
  continue executing any remaining entries. This field may optionally be
  provided as a base64 encoded string.
  EOT
}
variable "rollback_ldif_path" {
  type        = string
  default     = "files/rollback.ldif"
  description = <<EOT
  Relative path from module's root to a templatized LDIF string used to attempt
  to rollback any changes in the event that execution of the `creation_ldif`
  results in an error. This may contain multiple LDIF entries. All LDIF entries
  are performed in order. If Vault encounters an error while executing an entry
  in the `rollback_ldif` it will attempt to continue executing any remaining
  entries. This field may optionally be provided as a base64 encoded string.
  EOT
}
variable "username_template" {
  type        = string
  default     = "v_{{.DisplayName}}_{{.RoleName}}_{{random 10}}_{{unix_time}}"
  description = <<EOT
  A template used to generate a dynamic username. 

  This will be used to fill in th `.Username` field within the `creation_ldif`
  string.
  EOT
}
variable "default_ttl" {
  type        = string
  default     = "1h"
  description = <<EOT
  Specifies the TTL for the leases associated with this role. 
  Accepts time suffixed strings ("1h") or an integer number of seconds. 

  Defaults to system/engine default TTL time. 
  
  The available units are: ns, us (or µs), ms, s, m, h.
  EOT
}
variable "max_ttl" {
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
  role_name = (
    length(var.role_name) > 0 ?
    var.role_name :
    "${var.mount_point}-dynamic-role"
  )
  creation_ldif_path      = "${path.module}/${var.creation_ldif_path}"
  deletion_ldif_path      = "${path.module}/${var.deletion_ldif_path}"
  rollback_ldif_path      = "${path.module}/${var.rollback_ldif_path}"
  role_template_file_path = "${path.module}/templates/role.json"
}