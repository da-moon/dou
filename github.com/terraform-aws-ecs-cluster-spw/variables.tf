variable "run_env" {
  description = "Run environment (dev/qa/uat/prod)"
}

variable "region" {
  description = "The region in which AWS operations will take place"
}

variable "name" {
  description = "The name of the ECS cluster"
}

variable "instance_type" {
  description = "The type of instance on which to host the cluster"
  default     = "m4.large"
}

variable "key_name" {
  description = "The name of the key used to access the host"
}

variable "security_groups" {
  description = "A comma-separated list of security group IDs"
}

variable "iam_instance_profile" {
  description = "The id of the instance profile to apply to hosts"
}

variable "user_data" {
  description = "Extra init scripts to run on the host"
  default     = ""
}

variable "desired_hosts" {
  description = "The number of host instances to run"
  default     = 3
}

variable "health_check_grace_period" {
  description = "How long to wait in seconds before performing health checks"
  default     = 300
}

variable "health_check_type" {
  description = "The type of health check to use, EC2 or ELB"
  default     = "EC2"
}

variable "subnet_ids" {
  description = "A comma-separated list of subnet IDs in which to run hosts"
}

variable "elb_names" {
  description = "A comma-separated list of ELB names to associate with the cluster's autoscaling group"
  default     = ""
}

variable "dns_ip" {
  description = "IP Address of the VPC DNS server"
}

variable "consul_client_key" {
  description = "Client encryption key for the Consul cluster"
}

variable "consul_cluster" {
  description = "Address of the consul cluster"
}

variable "detailed_monitoring" {
  description = "Enable detailed EC2 monitoring"
  default     = false
}

variable "datadog_enabled" {
  description = "Enable Datadog monitoring"
  default     = false
}

variable "datadog_api_key" {
  description = "Datadog API key"
  default     = ""
}
