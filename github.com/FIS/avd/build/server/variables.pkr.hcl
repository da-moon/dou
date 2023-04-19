# Variable for packer

variable "client_id" {
  type        = string
  description = "Azure Service Principal App ID."
}

variable "client_secret" {
  type        = string
  description = "Azure Service Principal Secret."
  sensitive   = true
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID."
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID."
}

variable "artifacts_resource_group" {
  type        = string
  description = "Packer Artifacts Resource Group."
}

variable "build_resource_group" {
  type        = string
  description = "Packer Build Resource Group."
}

variable "source_image_publisher" {
  type        = string
  description = "Windows Image Publisher."
  default = "MicrosoftWindowsDesktop"
}

variable "source_image_offer" {
  type        = string
  description = "Windows Image Offer."
  default = "Windows-10"
}

variable "source_image_sku" {
  type        = string
  description = "Windows Image SKU."
  default = "20h2-evd"
}

variable "source_image_version" {
  type        = string
  description = "Windows Image Version."
  default = "latest"
}

variable "managed_image_name" {
  type        = string
  description = "The name of the image."
  default = "windows-packer-devicewise"
}

# Variables for Ansible playbook

variable "azure_login_username" {
  type        = string
  description = "Username for Azure login."
}

variable "azure_login_password" {
  type        = string
  description = "Password for azure login."
  sensitive   = true
}

variable "azure_artifact_org" {
  type        = string
  description = "Organization for azure artifact."
}

variable "azure_artifact_username" {
  type        = string
  description = "Username for azure artifact."
}

variable "azure_artifact_version" {
  type        = string
  description = "Version of the device wise."
}

variable "azure_artifact_filename_workbench" {
  type        = string
  description = "The filename of the device wise workbench installer saved in azure artifacts."
}

variable "azure_artifact_filename_gateway" {
  type        = string
  description = "The filename of the Asset Gateway installer saved in azure artifacts."
}
