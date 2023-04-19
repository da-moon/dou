variable "tfc_vault_workspace" {
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
