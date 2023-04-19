variable "tfc_target_workspace" {
  description = "Workspace where the role_id and secret_id variables are set"
  type        = string
}

variable "tfc_organization" {
  description = "Organization where the target workspace resides"
  type        = string
}

variable "role_id" {
  description = "Admin Approle ID used to login to Vault and create the objects"
  type        = string
}

variable "secret_id" {
  description = "Admin Secret ID used to login to Vault and create objects"
  type        = string
}

variable "admin_namespace" {
  description = "Name of the HCP Admin namespace to login to"
  type        = string
  default     = "admin"
}

## Child Namespace Variables

variable "auth_path" {
  description = "Path where the auth method will be mounted. Defaults to /approle."
  type        = string
  default     = null
}

variable "role_name" {
  description = "Name of the role that will be created for machine based access"
  type        = string
  default     = "admin_role"
}

variable "new_ns" {
  description = "Name of the HCP Vault namespace to create"
  type        = string
}

variable "auth_type" {
  description = "(Optional) Authentication type that will be used for the Vault Auth Backend. Defaults to approle"
  type        = string
  default     = "approle"
}

variable "auth_desc" {
  description = "(Optional) Description that will be used for the Vault Auth Backend"
  type        = string
  default     = "Admin Approle authentication method for machine based access"
}


variable "default_lease_ttl" {
  description = "(Optional) Default lease TTL that will be assigned to tokens on the auth mount"
  type        = string
  default     = "3h"
}

variable "max_lease_ttl" {
  description = "(Optional) Max lease TTL that will be assigned to tokens on the auth mount"
  type        = string
  default     = "6h"
}

### TFC Vars
