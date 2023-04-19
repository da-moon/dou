variable "app_name" {
  description = "Name of the app used for tags"
  type        = string
  default     = ""
}
variable "stage_name" {
  description = "Name of the stage used for tags"
  type        = string
  default     = ""
}
variable "profile_name" {
  description = " Name of the EKS Fargate Profile"
  type        = string
  validation {
    condition     = length(var.profile_name) > 0
    error_message = "Fargate Profile Name is required."
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
variable "subnet_ids" {
  description = " Identifiers of private EC2 Subnets to associate with the EKS Fargate Profile"
  type        = list(string)
  default     = []
}
variable "pod_execution_role_arn" {
  description = "Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Fargate Profile"
  type        = string
  validation {
    condition     = length(var.pod_execution_role_arn) > 0
    error_message = "Fargate pod execution role arn is required."
  }
}
variable "selectors" {
  description = "List of objects with Kubernetes Pods to execute in EKS Fargate Profile"
  type        = any
}