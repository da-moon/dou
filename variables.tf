variable "role_name" {
  description = "The name of the policy"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the IAM policy"
  type        = string
  default     = null
}

variable "policy_path" {
  description = "Path in which to create the policy."
  type        = string
  default     = "/"
}

variable "policy" {
  description = "The policy document"
  type        = string
}

variable "tags" {
  description = "A mapping of custom tags"
  type        = map(any)
  default     = {}
}