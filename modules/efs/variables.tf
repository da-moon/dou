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

variable "private_subnet_ids" {
  description = "List of private subnet IDs. Must be in at least two different availability zones. "
  type        = list(string)
  default     = []
}

variable "create_efs" {
  description = "Create EFS"
  type        = bool
  default     = false
}
