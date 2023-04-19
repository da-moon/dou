##### HCP Variables #####
variable "hcp_client_id" {
  description = "(Required) Username used to connect and authenticate with HashiCorp Cloud Platform"
  type        = string
}

variable "hcp_secret_id" {
  description = "(Required) Password used to connect and authenticate with HashiCorp Cloud Platform"
  type        = string
}

variable "hcp_region" {
  description = "(Required) Region where the HCP Vault cluster will be deployed"
  type        = string
}

variable "tfc_team_name" {
  description = "(Optional) Name of the TFC team that will be created"
  type        = string
  default     = "hcp_team_output"
}


variable "tfc_organization" {
  description = "(Required) Name of the TFC Organization where the workspaces reside"
  type        = string
  default     = "DoU-TFE"
}

variable "oauth_token_id" {
  description = "(Required) Oauth Token ID used for the VCS integration"
  type        = string
}

variable "tfc_ec2_agent_name" {
  description = "(Optional) Name of the Agent Pool that will be created."
  type        = string
  default     = "ec2-tfc-agents"
}

variable "tfc_ec2_agent_description" {
  description = "(Optional) Description for the TFC Agent Pool that will be created"
  type        = string
  default     = "TFC Agent Pool for Terraform execution with the AWS environment."
}

variable "aws_secret_key" {
  description = "(Required) AWS Secret Key that will be used for initial authentication during HCP cluster instantiation"
  type        = string
}

variable "aws_access_key" {
  description = "(Required) AWS Access Key that will be used for initial authentication during HCP cluster instantiation"
  type        = string
}
