
variable "artifacts_bucket_name" {
  description = "S3 bucket name for CI/CD automation, where pipeline artifacts are stored"
}

variable "region" {
  description = "The region where all the resources will de deployed"
  type        = string
}

variable "env_name" {
  description = "Name of the TeamCenter environment"
  type        = string
}

variable "force_regenerate" {
  description = "Forces running again the generate deployment scripts stage even if there are no changes"
  type        = bool
  default     = false
}

