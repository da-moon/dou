
variable "env_name" {
  description = "Teamcenter environment name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the corporate machine"
  type        = string
}

variable "artifacts_bucket_name" {
  description = "Name of the S3 bucket having the deployment scripts"
  type        = string
}

variable "force_rebake" {
  description = "If true, the corporate AMI will be regenerated even if there are no changes"
  type        = string
}

variable "ignore_tc_errors" {
  description = "If true, errors installing teamcenter will be ignored"
  type        = string
}
