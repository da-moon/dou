variable "service_name" {
  description = "Service this ALB will be serving directly"
}

variable "subnets" {
  description = "Subnets to start this ALB across"
}

variable "run_env" {
  description = "Run Environment"
}

variable "alb_idle_timeout" {
  description = "Idle timeout for ALB connections"
}

variable "hosted_zone_id" {
  description = "Id of hosted zone to put DNS entry"
}

variable "security_groups" {
  description = "Comma separated list of SGs to associate with this ALB"
}

variable "optional_subdomain" {
  description = "Used in route53 record -> service.(optional_subdomain.)hosted_zone_name - Include the period after the subodmain because it is optional"
  default     = ""
}

