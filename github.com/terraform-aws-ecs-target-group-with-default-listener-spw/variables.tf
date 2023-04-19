variable "service_name" {
  description = "Service this ALB will be serving directly"
}

variable "alb_arn" {
  description = "ARN of ALB to route traffic to"
}

variable "alb_listener_port" {
  description = "Traffic sent to this port on the ALB will be routed to this listener, on this port."
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
  default     = "/health"
}

variable "health_check_interval" {
  description = "How often to check the health of services"
}

variable "vpc_id" {
  description = "VPC to start target group in"
}

