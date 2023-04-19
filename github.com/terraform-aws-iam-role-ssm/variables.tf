variable "name" {
  description = "The unique name of the role"
  type        = string
}

variable "policy" {
  description = "Policy that grants an entity permission to assume the role."
  type        = string
}

variable "description" {
  description = "Description of the role."
  type        = string
  default     = null
}

variable "force_detach_policies" {
  description = "Whether to force detaching any policies the role has before destroying it."
  type        = bool
  default     = false
}

variable "managed_policy_arns" {
  description = "Set of exclusive IAM managed policy ARNs to attach to the IAM role. If this attribute is not configured, Terraform will ignore policy attachments to this resource."
  type        = list(string)
  default     = []
}

variable "permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the role."
  type        = string
  default     = null
}

variable "max_session_duration" {
  description = "Maximum session duration (in seconds) that you want to set for the specified role. This setting can have a value from 1 hour to 12 hours."
  type        = number
  default     = 3600
}

variable "inline_policy" {
  description = "Configuration block defining an exclusive set of IAM inline policies associated with the IAM role."
  type = list(object({
    name   = string
    policy = string
  }))
  default = []
}

variable "path" {
  description = "Path to the role"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of custom tags"
  type        = map(any)
  default     = {}
}