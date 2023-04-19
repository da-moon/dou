
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

variable "installation_prefix" {
  description = "A prefix to add to all resources created. Used to support multiple different installations of engineering in cloud."
  type        = string
}

variable "force_rebake" {
  description = "If true, the build server AMI will be recreated again. Used when the TeamCenter available software in the S3 bucket changes."
  type        = bool
  default     = false
}

variable "machines" {
  description = "Object describing TeamCenter machine names, instance types and number of instances"
  type      = object({
    build_server = object({
       instance_type = string
    })
  })
}

variable "delete_db_data" {
  description = "If true, all database data will be deleted as part of db initialization"
  type        = bool
  default     = false
}

