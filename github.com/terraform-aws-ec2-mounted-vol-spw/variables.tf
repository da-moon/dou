variable "ami" {
 # default = "ami-0b1e2eeb33ce3d66f" # Amazon Linux # Add ami name
  default = "ami-0f93d07b3ad6f27f8" 
}

variable "instance_type" {
  description = "The type of instance on which to host the instance"
  default = "t2.2xlarge"
}

variable "region" {
  default = "us-west-2"
}

variable "key_name" {
  description = "The KeyName to use when creating the instance"
  default = "teamcenter"
}

variable "vpc_security_group_ids" {
  description = "Array of security group id's"
  default = "sg-01be4fec51f3c5174"
}

variable "subnet_id" {
  description = "Thye VPC Subnet to launch in"
  default = "subnet-0f6fd7ca002f5ddd8"
}

variable "instance_name" {
  description = "The name of the instance"
  default = "buildserver"
}