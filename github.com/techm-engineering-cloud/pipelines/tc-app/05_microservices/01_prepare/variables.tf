
variable "artifacts_bucket_name" {
  description = "S3 bucket name for CI/CD automation, where pipeline artifacts are stored"
}

variable "force_rebake" {
  description = "If true, the build server AMI will be recreated again. Used when the TeamCenter available software in the S3 bucket changes."
  type        = bool
  default     = false
}
variable "region" {
  description = "AWS region"
  type        = string
}

variable "ignore_tc_errors" {
  description = "If true the installation errors that can happen when team center is not installed on purpose will be ignored"
  type        = bool
  default     = true
}

variable "env_name" {
  description = "Name of the environment, used for tagging and naming resources"
}

variable "installation_prefix" {
  description = "installation prefix for env"
}

variable "extra_kube_admin_role" {
  description = "Additional role ARN to give kubernetes admin permissions, if any."
  default     = ""
}

variable "eks_instances" {
  description = "Object describing eks number of instances"
  type = object({
    min_instances     = number
    desired_instances = number
    max_instances     = number
    instance_type     = string
  })
  default = {
    min_instances     = 2
    desired_instances = 2
    max_instances     = 4
    instance_type     = "m5.large"
  }
}
