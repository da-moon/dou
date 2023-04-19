
variable "vpc_id" {}

variable "subnet_cidr_1" {}

variable "subnet_cidr_2" {}

variable "nat_gateway_id_1" {}

variable "nat_gateway_id_2" {}

variable "key_name" {
  description = "SSH key name"
}

variable "ami_id" {
  description = "AMI for the build server"
}

variable "subnet_id" {}

