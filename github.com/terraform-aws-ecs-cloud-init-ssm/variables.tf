variable "userify_group_api_key" {
  description = "The api key for the ECS userify group"
}

variable "userify_group_api_id" {
  description = "The api id for the ECS userfiy group"
}

variable "cluster_name" {
  description = "Name of the cluster"
}

variable "datadog_api_key" {
  description = "The Datadog API key"
  default     = ""
}

variable "efs_address" {
  description = "Address of EFS share to mount to this volume"
}

