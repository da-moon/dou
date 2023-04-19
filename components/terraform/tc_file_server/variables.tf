
variable "artifacts_bucket_name" {
  type = string
}

variable "env_name" {
  description = "Name of the teamcenter environment"
}

variable "installation_prefix" {
  description = "A prefix to add to all resources created. Used to support multiple different installations of engineering in cloud"
}

variable "force_rebake" {
  type = bool
}

variable "ssh_key_name" {
  description = "Name of the SSH key for connecting to the build server"
}

variable "instance_type" {
  description = "type of the instance"
}

variable "max_instances" {
  description = "Max no. of instances created"
}

variable "min_instances" {
  description = "Min no. of instances created"
}

variable "build_subnet_id" {
  type = string
}

variable "lb_subnets" {
  description = "List of subnets where the file server load balancer will be deployed"
  type        = list(string)
}

variable "instance_subnets" {
  description = "List of subnets where the file servers instances will be deployed"
  type        = list(string)
}

