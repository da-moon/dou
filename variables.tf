variable "region" {
  description = "AWS region"
  type        = string
  //default     = "us-east-2"
  default     = "ca-central-1"
}

variable "cluster_name" {
  description = "Name of the the eks cluster"
  type        = string
  default     = "eks-tc"
}

variable "vpc_id" {
  description = "Identifier of the VPC where the resources are located"
  default = "vpc-0057695e5d2750a83"
}

variable "private_env_subnet_ids" {
  description = "IDs of the subnets where the build server runs"
  type        = list(string)
  default = [
  "subnet-063702f979dfee877",
  "subnet-017f7dfc06e2c3b5a",
]
}

variable "instance_type" {
  description = "type of the instance"
  default = ["m5.2xlarge"]
}


variable "min_size" {
  description = "type of the instance"
  default = 1
}

variable "max_size" {
  description = "type of the instance"
  default = 3
}

variable "desired_size" {
  description = "type of the instance"
  default = 1
}
