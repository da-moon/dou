
variable "artifacts_bucket_name" {
  description = "S3 bucket name for CI/CD automation, where pipeline artifacts are stored"
}

variable "deployment_center" {
  description = "Different settings for Deployment Center"
  type        = object({
    folder_to_install = string
    instance_type     = string
    backup_config     = object({
      enabled         = bool
      cron_schedule  = string
      retention_days = number
    })
  })
}

variable "delete_data" {
  description = "If true existing DeploymentCenter data will be deleted, forcing a full reinstall"
  type        = bool
  default     = false
}

variable "force_rebake" {
  description = "If true, the build server AMI will be recreated again. Used when the TeamCenter available software in the S3 bucket changes."
  type        = bool
  default     = false
}

variable "installation_prefix" {
  description = "Prefix to use for naming resources"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate to use for the load balancer"
  type        = string
}
