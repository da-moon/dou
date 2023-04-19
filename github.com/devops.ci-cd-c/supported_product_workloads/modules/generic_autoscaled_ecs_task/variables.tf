variable "lb_target_group_arn" {
  description = "The ARN of the ALB target group to associate with the service"
}

variable "cluster_name" {
  description = "The name of the cluster to run the service on"
}

variable "container_image" {
  description = "Name of image used for service, including ECR namespace"
}

variable "container_memory" {
  description = "The maxmimum of host memory to allocate for the container - ECS will terminate if container exceeds this amount"
  default     = 1024
}

variable "container_memory_reservation" {
  description = "The amount of host memory to reserve for the container at all times"
  default     = 256
}

variable "so_max_conn" {
  description = "Override the default setting for net.core.somaxconn"
  default     = 1024
}

variable "container_port" {
  description = "Port the container should be listening on for traffic."
}

variable "desired_services" {
  description = "The desired number of services to run on the cluster"
  default     = 3
}

# variable "gelf_labels" {
#   description = "Arbitrary labels to attach to the gelf log message"
# }
#
# variable "logstash_gelf_udp_port" {
#   description = "Port that logstash is accepting GELF UDP log messages over"
# }
#
# variable "logstash_address" {
#   description = "Address of logstash cluster for, will bet set in LOGSTASH_ADDRESS env variable"
# }
#
# variable "logstash_tcp_port" {
#   description = "Port that logstash is accepting json TCP log messages over"
# }
#
# variable "logstash_udp_port" {
#   description = "Port that logstash is accepting json UDP log messages over"
# }

variable "service_name" {
  description = "Name of generic service to be set in task definition"
}

variable "service_iam_role" {
  description = "IAM role for the service to register load balancer containers"
}

variable "task_iam_role_arn" {
  description = "IAM role for the task"
}

variable "container_version" {
  description = "The version of the container image to use"
}

variable "vault_token" {
  description = "Auth token for vault"
}

variable "consul_url" {
  description = "URL of the Consul host (no trailing slash)"
}

variable "vault_url" {
  description = "URL of the Vault host (no trailing slash)"
}

variable "minimum_healthy_percent" {
  description = "Enables rolling deploys without starting new instances. I.E. Kill a task to start another."
}

variable "subnets" {}
variable "security_groups" {}
variable "keys_dir" {}
variable "consul_token" {}
variable "project_name" {}
