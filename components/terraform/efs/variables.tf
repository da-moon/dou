variable "env_name" {
  description = "Name of the environment, used for tagging and naming resources"
}

variable "fs_service" {
  description = "Service that uses the EFS storage"
}

variable "private_subnet_ids" {
  description = "IDs of the subnets where the EC2 insatnces run"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "IDs of public subnets, used for allowing access to EFS while using packer to build images"
}

variable "vpc_id" {
  description = "Identifier of the VPC where the resources are located"
}

variable "prefix_name" {
  description = "Prefix to be used in the EFS naming"
}