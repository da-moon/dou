
variable "env_name" {
  description = "Name of the environment, used for tagging and naming resources"
}

variable "vpc_id" {
  description = "Already existing VPC"
  type        = string
}

variable "cidr_public_subnets" {
  description = "Public CIDR range for VPC"
  type        = list(string)
}

variable "cidr_private_build_subnets" {
  description = "Private CIDR range for Build sever in a VPC"
  type        = list(string)
}