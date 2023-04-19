# https://www.terraform.io/docs/configuration/variables.html

# Project Config
variable "project_name" {
}

variable "run_env" {
  description = "run environment (devops/dev/sand/qa/stage/prep/prod)"
}

variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}

## Bastian Host Config
## NOTE: If you change the ami it is possible the user will change, i.e make sure to update the default `user` variable to reflect your change.
variable "ami" {
  default = "ami-02541b8af977f6cdd" # Amazon Linux
}
variable "ssh_user" {
  default = "ec2-user"
}
variable "instance_type" {
  default = "t3.micro"
}

# AWS Config
variable "aws_profile" {
  default = "default"
}

variable "aws_region" {
  default = "us-west-1"
}

variable "cidr_block" {
  default = "10.10.10.0/24"
}

variable "azs_public" {
  default = ["us-west-1a"]
}

variable "availability_zones" {
  default = ["us-west-1a"]
}

variable "public_subnet" {
  default = ["10.10.10.128/27"]
}

variable "public_subnet_name" {
  default = ["Public subnet"]
}

variable "instance_tenancy" {
  default = "default"
}

variable "azs_private" {
  default = ["us-west-1a"]
}

variable "private_subnet" {
  default = ["10.10.10.32/27"]
}

variable "private_subnet_name" {
  default = ["Private subnet"]
}

variable "s3_bucket" {}

# ECR
variable "ecr_name" {}

variable "eip_name" {}


