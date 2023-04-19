variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "mumbai"
}
variable "aws_regions" {
  description = "aws regions"
  type        = map(string)
  default = {
    north-virginia = "us-east-1"
    mumbai         = "ap-south-1"
  }
}
variable "create_vpc" {
  description = "Create VPC swich"
  type        = bool
  default     = true
}
variable "vpc_cidr" {
  description = "Default Supernet that all networks reside within"
  type        = string
  default     = "172.21.0.0/16"
}

variable "private_subnets" {
  description = "Private subnets of VPC"
  type        = list(string)
  default     = ["172.21.21.0/24", "172.21.22.0/24"]
}
variable "public_subnets" {
  description = "Public subnets of VPC"
  type        = list(string)
  default     = ["172.21.11.0/24", "172.21.12.0/24"]
}
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
  type = bool
  default     = false
}
variable "k8s_version" {
  description = "k8s cluster version"
  default     = "1.20"
  type        = string
}
variable "private_networking" {
  description = "Pruvate networking switch"
  type        = bool
  default     = false
}
# max 2 AZs
variable "multi_az_deployment" {
  description = "Multi availability zone. Max 2"
  type        = bool
  default     = true
}
variable "app_ingress_gateway_container_port" {
  description = "App ingress Gateway container port"
  type        = number
  default     = 8080
}
variable "app_create_efs" {
  description = "EFS creation switch"
  type        = bool
  default     = true
}

variable "envoy_proxy_egress_cidr_block" {
  description = "Envoy Proxy CIDR block"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "enabled_cluster_log_types" {
  description = "List of the desired control plane logging to enable."
  type        = list(string)
  default     = ["api", "audit", "authenticator", "scheduler", "controllerManager"]
}