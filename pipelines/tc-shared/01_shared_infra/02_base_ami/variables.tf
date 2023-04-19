
variable "region" {
  description = "The region where all the resources will de deployed"
  type        = string
}

variable "artifacts_bucket_name" {
  description = "S3 bucket name for CI/CD automation, where pipeline artifacts are stored"
  type        = string
}

variable "force_rebake" {
  description = "Indicates if rebaking should be done regardless of any changes"
  default     = false
}

