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

variable "scaling_memory_threshold" {
  description = "This threshold is used to determine when cloudwatch alarms will be triggered if memory on these containers (200+ is recommended)"
  default     = 200
}

