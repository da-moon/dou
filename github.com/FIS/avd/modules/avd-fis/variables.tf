# Credentials

variable "az_service_principal" {
  description = "Azure Service Principal ID"
  type    = string
}
variable "az_client_secret" {
  description = "Azure Client Secret"
  type    = string
}
variable "az_subscription_id" {
  description = "Azure Subscription ID"
  type    = string
}
variable "az_tenant_id" {
  description = "Azure Tenant ID"
  type    = string
}

variable "resource_group" {
  description = "Azure Resource Group"
  type        = string
}

variable "avd_host_pool_size" {
  type        = number
  description = "Number of session hosts to add to the AVD host pool"
  default     = 1
}

variable "avd_users" {
  type        = list(string)
  description = "List of users authorized to access AVD."
}

variable "packer_name" {
  type        = string
  description = "Image name of the packer."
}