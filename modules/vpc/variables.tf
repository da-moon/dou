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
variable "create_vpc" {
  description = "Create VPC"
  type        = bool
  default     = true
}
variable "aws_availability_zones" {
  description = "Aws availability zones"
  type        = list(string)
  default = [
    "ap-south-1a",
    "ap-south-1b",
    "ap-south-1c",
  ]
}
variable "cidr" {
  description = "Default Supernet that all networks reside within"
  type        = string
  default     = "172.21.0.0/16"
}

variable "private_subnets" {
  description = "Private subnets of VPC"
  type        = list(any)
  validation {
    condition     = length(var.private_subnets) > 0
    error_message = "Private subnets can't be an empty list."
  }
}
variable "public_subnets" {
  description = "Public subnets of VPC"
  type        = list(any)
  validation {
    condition     = length(var.public_subnets) > 0
    error_message = "Public subnets can't be an empty list."
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

variable "multi_az_deployment" {
  description = "Multi availability zone. Max 2"
  type        = bool
  default     = true
}

variable "nat_gateways" {
  description = "Number of NAT Gateways to be provisioned. This number cannot exceed the total number of Public Subnets in all AZs"
  type        = number
  default     = 1

}