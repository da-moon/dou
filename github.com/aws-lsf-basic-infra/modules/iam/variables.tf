variable "iam_role"{
  description = "Name for IAM role"
  type        = string
  default     = "eda-ec2-role"
}
variable "iam_instance_profile"{
  description = "Name for IAM instance profile resource"
  type        = string
  default     = "eda-ec2-role"
}

variable "iam_role_policy"{
  description = "Name for IAM role policy resource"
  type        = string
  default     = "eda-ec2-role-policy"
}
variable "bucket"{
  description = "name of the bucket for logs"
  type        = string
  default     = "eda-logs"
}