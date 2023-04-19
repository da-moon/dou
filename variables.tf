# The variables file is structured in different sections. The "General variables" section is to be used for any variables that are present in more than one type of Terraform resource or module
# If a variable is unique to one type of Terraform resource or module then there is a corresponding variables section for said resource or module

# General variables

variable "service_name" {
  description = "The name of the ECS service that is being created"
}

variable "container_port" {
  description = "The port on the container which the load balancer will forward traffic to"
}

# ECS Service variables

variable "desired_count" {
  description = "The number of instances of the Task Definition to place and keep running"
}

variable "cluster_arn" {
  description = "The ARN of the ECS cluster where the service will be created"
}

variable "service_iam_role" {
  description = "The IAM role that allows the ECS container agent to talk to and issue commands to the load balancer."
}

variable "alb_target_group_arn" {
  description = "The ARN of the target group to associate with the service"
}

# ECS Task Definition variables

variable "task_definition_name" {
  description = "A unique name for the task definition"
}

variable "task_role_arn" {
  description = "The ARN of the IAM role that allows the ECS task to make calls to other AWS resources"
}

# Task Definition template file variables

variable "container_image" {
  description = "Name of image used for service, including ECR namespace"
}

variable "container_version" {
  description = "The version of the container image to use"
}

variable "container_memory" {
  description = "The maxmimum of host memory to allocate for the container - ECS will terminate if container exceeds this amount"
  default     = 256
}

variable "container_memory_reservation" {
  description = "The amount of host memory to reserve for the container at all times"
  default     = 256
}

variable "consul_host" {
  description = "URL of the Consul host (no trailing slash)"
}

variable "logging_host" {
  description = "URL of the Logstash host (no trailing slash)"
}

variable "gelf_address" {
  description = "DNS address of the gelf cluster"
}

variable "gelf_port" {
  description = "The port of the gelf cluster"
}

variable "gelf_labels" {
  description = "Arbitrary labels to attach to the gelf log message"
}

variable "logstash_address" {
  description = "The address of the logstash cluster. This will bet set in the LOGSTASH_ADDRESS environment variable"
}

variable "logstash_tcp_port" {
  description = "The port that logstash is accepting JSON TCP log messages over"
}

variable "logstash_udp_port" {
  description = "The port that logstash is accepting JSON UDP log messages over"
}

variable "container_user" {
  description = "The user the ENTRYPOINT or CMD commmands should be run as. This should map to the USER in the Dockerfile"
}

