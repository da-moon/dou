variable "ami" {
  description = "The AMI to use to build the instance"
}

variable "instance_name" {
  description = "The name of the instance"
}

variable "instance_type" {
  description = "The type of instance on which to host the instance"
  default = "m4.large"
}

variable "env" {
  description = "The environment the instance will reside in"
}

variable "key_name" {
  description = "The KeyName to use when creating the instance"
}

variable "subnet_id" {
  description = "The VPC Subnet to launch in"
}

variable "iam_instance_profile"
{
  description = "The iam_instance_profile"
}

variable "security_group_ids" {
  description = "The security groups to associate with the instance"
}

# Configuring IPSEC
variable "aws_environment_network" {
  description = "The AWS environment network this VPN gateway is being configured for"
}

variable "office_gateway" {
  description = "The IP address for the office gateway"
}

variable "office_network" {
  description = "The office network"
}

variable "client_network" {
  description = "The VPN client network"
}

variable "ipsec_shared_secret_key" {
  description = "The shared secret key for IPSEC"
}

variable "office_name" {
  description = "Office for the VPN tunnel connection"
}
