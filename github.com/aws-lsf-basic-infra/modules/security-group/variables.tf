variable "vpc_id" {
  description = "VPC where servers will reside"
  type        = string
  default     = "vpc-0000000000000000e"
}
variable "security_group_name"{
  description = "name for the security group"
  type = string
  default = "securityGroupLSF"
}