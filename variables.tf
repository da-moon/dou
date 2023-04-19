variable "name" {
  description = "The name of the service and task definition"
}

variable "container_definitions" {
  description = "A json array of container definitions"
}

variable "cluster_id" {
  description = "The name of the cluster on which to run this service"
}

variable "desired_count" {
  description = "The desired number of service container groups to run on the cluster"
}

variable "alb_container_name" {
  description = "Name of the container for the ALB"
}

variable "alb_container_port" {
  description = "Port of the container for the ALB"
}

variable "alb_target_group_arn" {
  description = "The ARN of the ALB target group to associate with the service"
}

variable "service_iam_role" {
  description = "IAM role for the service to register load balancer containers"
}

variable "task_iam_role" {
  description = "IAM role for the task to run under"
}

variable "minimum_healthy_percent" {
  description = "Enables rolling deploys without starting new instances. I.E. Kill a task to start another."
}

variable "health_check_grace_period_seconds" {
  description = "Grace period in seconds before health check starts"
}

