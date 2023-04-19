variable "ami" {
  description = "The AMI to use to build the instance"
}

variable "instance_type" {
  description = "The type of instance on which to host the instance"
  default     = "t2.medium"
}

variable "key_name" {
  description = "The KeyName to use when creating the instance"
}

variable "security_group_ids" {
  description = "The security groups to associate with the instance"
}

variable "subnet_id" {
  description = "Thye VPC Subnet to launch in"
}

variable "instance_name" {
  description = "The name of the instance"
}

variable "env" {
  description = "The environment the instance will reside in"
}

variable "bind_ipaddress" {
  description = "Static IP address for the BIND host"
}

variable "internal_route53_address" {
  description = "Internal VPC DNS resolver"
}

variable "count_bind_instance" {
  description = "Used to indicate how many bind instances to create, possible 0, based on environment"
}

