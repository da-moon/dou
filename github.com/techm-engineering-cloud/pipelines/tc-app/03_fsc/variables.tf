
variable "artifacts_bucket_name" {
  description = "S3 bucket name for CI/CD automation, where pipeline artifacts are stored"
}

variable "region" {
  description = "The region where all the resources will de deployed"
  type        = string
}

variable "env_name" {
  description = "Name of the environment, used for tagging and naming resources"
}

variable "force_rebake" {
  description = "If true, the build server AMI will be recreated again. Used when the TeamCenter available software in the S3 bucket changes."
  type        = bool
  default     = false
}

variable "ignore_tc_errors" {
  description = "If true the installation errors that can happen when team center is not installed on purpose will be ignored"
  type        = bool
  default     = true
}

variable "machines" {
  description = "Object describing TeamCenter machine names, instance types and number of instances"
  type      = object({
    enterprise_tier = object({
       instance_type = string
    })
  })
}
