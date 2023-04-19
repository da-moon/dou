variable "app_name" {
  description = "Name of the app used for tags"
  type        = string
  validation {
    condition     = length(var.app_name) > 0
    error_message = "App name is required."
  }
}
variable "stage_name" {
  description = "Name of the stage used for tags"
  type        = string
  validation {
    condition     = length(var.stage_name) > 0
    error_message = "Stage Name is required."
  }
}
variable "cluster_name" {
  description = "Choose a name for the EKS Cluster."
  type        = string
  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "Cluster Name is required."
  }
}
variable "cluster_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled."
  type        = bool
  default     = false
}
variable "cluster_version" {
  description = "Desired Kubernetes master version."
  type        = string
  default     = "1.20"
}
variable "role_arn" {
  description = "ARN of the IAM role that provides permissions for the Kubernetes control plane to make calls to AWS API operations on your behalf"
  type        = string
}
variable "public_subnet_ids" {
  description = "List of public subnet IDs. Must be in at least two different availability zones. "
  type        = list(string)
  validation {
    condition     = length(var.public_subnet_ids) > 0
    error_message = "Public subnet IDs list cannot be empty."
  }
}
variable "private_subnet_ids" {
  description = "List of private subnet IDs. Must be in at least two different availability zones. "
  type        = list(string)
  validation {
    condition     = length(var.private_subnet_ids) > 0
    error_message = "Private subnet IDs list cannot be empty."
  }
}
variable "enabled_cluster_log_types" {
  description = "List of the desired control plane logging to enable."
  type        = list(string)
  default     = ["api", "audit", "authenticator", "scheduler", "controllerManager"]
}
variable "private_networking" {
  description = "Enable Private Networking"
  type        = bool
}