
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

variable "enterprise_security_group_id" {
  description = "ID of the security group used by the build server"
}

variable "machine_name" {
  description = "Identifier for the instances"
}

variable "active_subnet_id" {
  description = "Subnet of the active instance"
}

variable "standby_subnet_id" {
  description = "Subnet of the standby instance"
}

variable "instance_type" {
  description = "type of the instance"
}

variable "sns_arn" {
  description = "Cloudwatch alarm"
  type        = string
}

variable "additional_alarm_actions" {
  description = "These are ARNs to alarm actions that will be appended to the one created by the module."
  type        = list(string)
  default     = []
}