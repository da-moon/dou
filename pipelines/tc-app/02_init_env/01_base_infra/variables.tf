variable "machines" {
  description = "Object describing TeamCenter machine names, instance types and number of instances"
  type = object({
    db = object({
      instance_type = string
    })
  })
}

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

variable "db_user" {
  description = "User name for RDS Database"
  default     = "admin"
}

variable "db_sm_user" {
  description = "Database username for Server Manager pool configuration"
  default     = "TCClusterDB"
}

variable "infodba_user" {
  description = "User name for infodba account"
  default     = "infodba"
}

variable "indexing_engine_user" {
  description = "User name for solr indexing engine"
  default     = "solr"
}

variable "indexing_engine_machine_user" {
  description = "User name for solr indexing engine machine"
  default     = "tc"
}

variable "fsc_machine_user" {
  description = "User name for FSC machine"
  default     = "tc"
}

variable "env_backup_config" {
  description = "Map for taking backups of TeamCenter components (EFS,RDS) specific to an environment"
  type = object({
    enabled        = bool
    cron_schedule  = string
    retention_days = number
  })
}

variable "sm_db_name" {
  description = "Name of the Server Manager tablespace"
  type        = string
  default     = "TCClusterDB"
}

##variables for https
variable "certificate_arn" {
  description = "ARN of the default SSL server certificate."
  type        = string
}

variable "ssl_policy" {
  description = "Name of the SSL Policy for the listener"
  type        = string
}

variable "is_https" {
  description = "enable https"
  type        = bool
}

## Variables for CIDR ranges

variable "env_cidr_private_subnets" {
  description = "Private CIDR range for env servers"
  type        = list(string)
  default     = null
}
