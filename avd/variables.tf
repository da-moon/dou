# Credentials

variable "az_service_principal" {
  type    = string
  description = "Azure service principal"
}

variable "az_client_secret" {
  type    = string
  description = "Azure client secret"
  sensitive = true
}

variable "az_subscription_id" {
  type    = string
  description = "Azure subscription id"
}

variable "az_tenant_id" {
  type    = string
  description = "Azure tenant id"
}

# AVD Variables

variable "resource_group" {
  type        = string
  description = "Azure resource group."
}
variable "avd_host_pool_size" {
  type        = number
  description = "Number of session hosts to add to the AVD host pool"
  default     = 1
}
variable "avd_users" {
  type        = list(string)
  description = "List of users authorized to access AVD."
  default = [
    "antonio.cabrera@digitalonus.com",
    "rodrigo.valdes@digitalonus.com",
    "leonel.perea@digitalonus.com",
    "edgar.lopez@digitalonus.com",
  ]
}

variable "packer_name" {
  type        = string
  description = "Custom image name of the packer."
  default = "windows-packer-devicewise"
}
