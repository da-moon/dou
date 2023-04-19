variable "vpc_id" {
  description = "The VPC ID."
  type        = string
}

variable "sg_name" {
  description = "Name of the security group. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "description" {
  description = "Security group description. Cannot be ''."
  type        = string
  default     = "Managed by Terraform"
}

variable "delete_rules" {
  description = "Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself."
  type        = bool
  default     = false
}

variable "ingress_rules" {
  description = "Configuration block for ingress rules. This argument is processed in attribute-as-blocks mode."
  type        = any
  default     = []
}

variable "egress_rules" {
  description = "Configuration block for egress rules. This argument is processed in attribute-as-blocks mode."
  type        = any
  default     = []
}

variable "tags" {
  description = "A mapping of custom tags"
  type        = map(any)
  default     = {}
}