
variable "env_name" {
  description = "Name of the environment, used for tagging and naming resources"
}

variable "vpc_id" {
  description = "Identifier of the VPC where the resources are located"
}

variable "service_name" {
  description = "Name of the service associated with the ALB"
}

variable "public_subnet_ids" {
  description = "Identifiers of the public subnets"
}

variable "svc_healthcheck_path" {
  description = "Path for the health check"
}

variable "svc_healthcheck_port" {
  description = "Port for the health check"
  type        = number
}

variable "certificate_arn" {
  description = "ARN of the default SSL server certificate."
  type        = string
}

variable "ssl_policy" {
  description = "Name of the SSL Policy for the listener"
  type        = string
}

variable "is_https" {
  description = "enable https"
  type        = bool
}