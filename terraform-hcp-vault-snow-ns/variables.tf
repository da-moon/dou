variable "namespace" {
  description = "Namespace that will be configured"
  type        = string
}

variable "secret_id" {
  description = "Approle Secret ID used to authenticate to Vault for this namespace. Generated from another workspace and pushed to tfvars"
  type        = string
}

variable "role_id" {
  description = "Approle Role ID used to authenticate to Vault for this namespace. Generated from antoher workspace and pushed to tfvars"
  type        = string
}

## App Role variables ##
variable "approle_path" {
  description = "Path where the Approle auth method will be mounted. Defaults to /approle."
  type        = string
  default     = "/approle"
}

variable "approle_description" {
  description = "Description for the Approle auth method"
  type        = string
  default     = "Approle authentication method for machine based access"
}

variable "approle_role_name" {
  description = "Name of the role id that will be created for machine based access"
  type        = string
  default     = "snow"
}

variable "approle_role_policies" {
  description = "Vault policies that will be associated with the token generated via the role id"
  type        = list(any)
  default     = ["ops"]
}

### TFE Variables

variable "tfc_organization" {
  description = "TFC organization where we will retrieve remote state"
  type        = string
}

variable "tfc_approle_workspaces" {
  description = "(Required) List of target workspaces where the approle will be pushed for GCE secret retrieval"
  type        = string
}
