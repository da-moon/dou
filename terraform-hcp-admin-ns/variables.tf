variable "tfc_organization" {
  description = "TFC organization where we will retrieve remote state"
  type        = string
}

variable "admin_approle_name" {
  description = "Name of the admin approle that will be created"
  type        = string
  default     = "admin_approle"
}

variable "admin_approle_description" {
  description = "Description for the admin approle that will be created"
  type        = string
  default     = "Used for subsequent Vault calls after initial setup"
}

variable "admin_approle_path" {
  description = "Path where the approle will be created. Defaults to /approle"
  type        = string
  default     = "approle"
}

variable "admin_approle_policy" {
  description = "Policy that will be assigned to the admin approle"
  type        = list(any)
  default     = ["hcp-root"]
}

variable "tfc_target_workspace" {
  description = "(Required) Workspace where the Admin Approle role_id and secret_id will be pushed"
  type        = string
}
