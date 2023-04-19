##### HCP Variables #####
variable "hcp_region" {
  description = "(Required) Region where the HCP Vault cluster will be deployed"
  type        = string
}

variable "generate_vault_token" {
  description = "Flag to generate HCP Vault admin token"
  type        = bool
  default     = true
}

variable "vault_tier" {
  description = "Tier to provision in HCP Vault - dev, standard_small, standard_medium, standard_large"
  type        = string
  default     = "dev"
  validation {
    condition     = var.vault_tier != "dev" || var.vault_tier != "standard_small" || var.vault_tier != "standard_medium" || var.vault_tier != "standard_large" || var.vault_tier != "starter_small" || var.vault_tier != "plus_small" || var.vault_tier != "plus_medium" || var.vault_tier != "plus_large"
    error_message = "The variable vault_tier must be \"dev\", \"standard_small\", \"standard_medium\", \"starter_small\", \"standard_large\", \"plus_small\", \"plus_medium\", or \"plus_large\"."
  }
}

variable "vault_cluster_name" {
  description = "The name (id) of the HCP Vault cluster."
  type        = string
  default     = "hcp-vault-cluster"
}

variable "min_vault_version" {
  description = "Minimum Vault version to use when creating the cluster. If null, defaults to HCP recommended version"
  type        = string
  default     = ""
}

variable "hvn_vault_id" {
  description = "The ID of the HCP Vault HVN."
  type        = string
  default     = "hcp-vault-hvn"
}

variable "hvn_cidr_block" {
  description = "CIDR block for the Hashicorp Virtual Network in HCP"
  type        = string
  default     = "172.25.16.0/20"
}

variable "cloud_provider" {
  description = "The cloud provider of the HCP HVN, HCP Vault, or HCP Consul cluster."
  type        = string
  default     = "aws"
}


variable "tfc_organization" {
  description = "TFC organization where we will retrieve remote state"
  type        = string
}

variable "tfc_vault_admin_workspace" {
  description = "Name of the Workspace where the root token will be pushed for the initial configuration"
  type        = string
}

variable "tfc_aws_networking_workspace" {
  description = "Name of the Workspace where the AWS networking configuration has been generated"
  type        = string
}
