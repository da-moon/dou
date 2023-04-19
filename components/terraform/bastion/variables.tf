
variable "env_name" {
  description = "Name of the environment, used for tagging and naming resources"
}

variable "ssh_key_name" {
  description = "Name of the SSH key for connecting to the bastion server"
}

variable "vpc_id" {
  description = "Identifier of the VPC where the bastion host will be launched"
}

variable "subnet_ids" {
  description = "List of identifiers of the subnets where the bastion host will be launched"
  type = list(string)
}

variable "eip_allocid" {
  description = "Allocation ID of an elastic IP to associate with the bastion server"
  type        = string
}
