variable "name" {
  description = "The unique name of the role"
}

variable "service" {
  description = "The name of the AWS service that can assume this role"
  default     = "ec2"
}

