variable "atlas_env_base_name" {
  description = "Atlas environment base names (development/qa/uat/production)"
}

variable "cluster_name" {
  description = "The name of the ECS cluster being deployed to"
}

variable "service_name" {
  description = "Name of ECS service to be scaled"
}

variable "min_services_desired" {
  description = "Minimum # of tasks to be run when scaling down"
  default     = 1
}

variable "max_services_desired" {
  description = "Maxium # of tasks to be scaled when scaling up"
  default     = 20
}

variable "scaling_cpu_threshold" {
  description = "This threshold is used to determine when cloudwatch alarms will be triggered if CPU on these containers (95 is recommended)"
  default     = 95
}

variable "metric_period" {
  description = "Default is 300s. A shorter period will scale your application up and down faster, a longer one means scaling won't respond to load as quickly."
  default     = 300
}

