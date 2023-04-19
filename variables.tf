
variable "ami_id_bastion" {
  default = "ami-09dd2e08d601bff67"
}

variable "ami_id_build_server" {
  default = "ami-0ee8244746ec5d6d4"
  description = "AMI id for the build server (defaults to CentOS 7)"
}

