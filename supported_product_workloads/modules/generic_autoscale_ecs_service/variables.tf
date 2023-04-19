variable "cluster_name" {
  description = "The name of the cluster to run the service on"
}

variable "container_image" {
  description = "Name of image used for service, including ECR namespace"
}

variable "container_memory" {
  description = "The maxmimum of host memory to allocate for the container - ECS will terminate if container exceeds this amount"
  default     = 2048
}

variable "container_memory_reservation" {
  description = "The amount of host memory to reserve for the container at all times"
  default     = 256
}

variable "container_port" {
  description = "Port the container should be listening on for traffic."
}

variable "desired_services" {
  description = "The desired number of services to run on the cluster"
  default     = 3
}


variable "service_name" {
  description = "Name of generic service to be set in task definition"
}

variable "ecs_task_execution_role" {
  description = ""
}

variable "task_iam_role_arn" {
  description = "IAM role for the task"
}

variable "container_version" {
  description = "The version of the container image to use"
}

variable "consul_host" {
  description = "URL of the Consul host (no trailing slash)"
}

variable "vault_host" {
  description = "URL of the vault host (no trailing slash)"
}

variable "minimum_healthy_percent" {
  description = "Enables rolling deploys without starting new instances. I.E. Kill a task to start another."
}

variable "lb_security_groups" {
  description = "Security_groups to apply to the ALB"
}

variable "lb_subnet_ids" {
  description = "subnet ids to start the ALB in"
}

variable "vpc_id" {
  description = "subnet ids to start the ALB in"
}

variable "run_env" {
  description = "Run Environment (dev/qa/uat/prod)"
}

variable "hosted_zone_id" {
  description = "ID of hosted zone to create the route53 alias record in."
}

variable "lb_idle_timeout" {
  description = "Idle timeout to set on ALB http://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancers.html#connection-idle-timeout"
}

variable "lb_drain_duration" {
  description = "Amount of time for the ALB to drain requests to services when they are being removed"
}

variable "aws_region" {
  description = "region to deploy service / ALB in"
}

variable "health_check_healthy_threshold" {
  description = "After X # of continuous successful checks, this service will be healthy"
}

variable "health_check_unhealthy_threshold" {
  description = "After X # of continuous unsuccessful checks, this service will be unhealthy"
}

variable "health_check_timeout" {
  description = "Timeout duration for health check requests"
}

variable "health_check_protocol" {
  description = "Protocol for health checks"
}

variable "health_check_path" {
  description = "Path to check (usually /health)"
  default     = "/health"
}

variable "health_check_interval" {
  description = "How often to check the health of services"
}

variable "lb_target_group_port" {
  description = "Port for target group"
}

variable "lb_listener_port" {
  description = "port the ALB listener will listen for traffic on"
}

variable "target_group_protocol" {
  description = "Default protocol for target group traffic"
}

variable "health_check_grace_period_seconds" {
  description = "Grace period in seconds before health check starts"
}

variable "health_check_matcher" {
  description = "HTTP code to use when checking for successful responses"
  default     = "200,301"
}
variable "vault_token" {
  description = "Vault token for api"
  default     = ""
}

variable "consul_token" {}
variable "subnets" {}
variable "security_groups" {}
variable "keys_dir" {}
variable "project_name" {}
