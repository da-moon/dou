
variable "installation_prefix" {
  description = "A prefix to add to all resources created. Used to support multiple different installations of engineering in cloud"
}

variable "ami_id" {
  description = "Base AMI for the build server"
}

variable "ssh_key_name" {
  description = "Name of the SSH key for connecting to the build server"
}

variable "iam_instance_profile" {
  description = "Instance profile for build server to assume IAM roles"
}

variable "wb_security_group_id" {
  description = "ID of the security group used by the build server"
}

variable "private_env_subnet_ids" {
  description = "IDs of the subnets where the build server runs"
  type        = list(string)
}

variable "target_group_arns" {
  description = "ARNs of the target groups for load balancers"
  type        = list(string)
}

variable "vpc_id" {
  description = "Identifier of the VPC where the resources are located"
}

variable "machine_name" {
  description = "Host name to set to the new instance"
}

variable "max_instances" {
  description = "Max no. of instances created"
}

variable "min_instances" {
  description = "Min no. of instances created"
}

variable "instance_type" {
  description = "type of the instance"
}

variable "env_name" {
  description = "Name of the teamcenter environment"
}

variable "has_gateway" {
  description = "True if the AMI includes Active Workspace Gateway"
  type        = bool
}

