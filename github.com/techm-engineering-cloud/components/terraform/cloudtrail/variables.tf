variable "trail_name" {
  description = "Name of the cloud trail"
}

##cloud watch group variables
variable "log_retention_days" {
  type    = number
  default = 90
}

variable "cloudwatch_log_group_name" {
  type    = string
  default = "tc-cloudtrail"
}

variable "bucket_prefix" {
  description = "Name of the S3 bucket to store logs in (required)."
}

variable "env_name" {
  description = "Name of the environment, used for tagging and naming resources"
}

variable "kms_key_id" {
  description = "kms key to encrypt the logs"
}

variable "is_multi_region_trail" {
  description = "Is this a multi-region trail? Secure option is default"
  type        = bool
  default     = true
}

variable "enable_log_file_validation" {
  description = "enable log file validation to detect tampering"
  type        = bool
  default     = true

}

variable "enable_logging" {
  description = "Enables logging for the trail. Defaults to true. Setting this to false will pause logging."
  default     = true
  type        = bool
}

variable "include_global_service_events" {
  description = "include global service events"
  type        = bool
  default     = true
}