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
  description = "Triggers creation of VPC"
  type        = bool
}
variable "vpcid" {
  description = "(Optional, Forces new resource) VPC ID"
  type        = string
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
variable "private_networking" {
  description = "Enable Private Networking"
  type        = bool
}
variable "ingress_gateway_container_port" {
  description = "Ingress port"
  type        = number
}
variable "multi_az_deployment" {
  description = "Multi availability zone. Max 2"
  type        = bool
  default     = true
}

variable "envoy_proxy_egress_cidr_block" {
  description = "Envoy Proxy CIDR block"
  type        = list(any)
  default     = ["1.2.3.4/32"]
}