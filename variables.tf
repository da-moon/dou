variable "service_name" {
  description = "Service this ALB will be serving directly"
}

variable "target_group_protocol" {
  description = "Default protocol for target group traffic"
}

variable "target_group_drain_duration" {
  description = "Drain duration for this target group (when services are dereigstered)"
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
  default = "/health"
}

variable "health_check_interval" {
  description = "How often to check the health of services"

}

variable "vpc_id" {
  description = "VPC to start target group in"
}

variable "alb_listener_arn" {
  description = "ARN of ALB Listener to route traffic to"
}

variable "rule_priority" {
  description = "Priority of this rule. A priority of 1 = default rule if no matches are found. So rules are excecuted low -> high and first match gets route. If no matches prioity of 1 is the path. "
}

variable "path_patterns" {
  description = "CSV list of path patterns to match this rule on"
}