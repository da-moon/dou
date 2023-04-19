variable "service_name" {
  description = "Service this ALB will be serving directly"
}

variable "subnets" {
  description = "Subnets to start this ALB across"
}

variable "run_env" {
  description = "Run Environment"
}

variable "alb_target_group_port" {
  description = "Port for target group"
}

variable "alb_idle_timeout" {
  description = "Idle timeout for ALB connections"
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

variable "health_check_matcher" {
  description = "codes to use when checking for a successful response from a target"
}

variable "hosted_zone_id" {
  description = "Id of hosted zone to put DNS entry"
}

variable "alb_listener_port" {
  description = "port the ALB listener will listen for traffic on"
}

variable "security_groups" {
  description = "Comma separated list of SGs to associate with this ALB"
}

variable "vpc_id" {
  description = "VPC to start target group in"
}

variable "optional_subdomain" {
  description = "Used in route53 record -> service.(optional_subdomain.)hosted_zone_name - Include the period after the subodmain because it is optional"
  default     = ""
}

variable "certificate_arn" {
  description = "ARN for the certificate"
}

variable "is_http_required" {
  default     = "no"
  description = "If HTTP Listener required, give 'yes'"
}

