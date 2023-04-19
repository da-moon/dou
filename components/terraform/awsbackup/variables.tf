variable "env_name" {
  description = "Name of the environment, used for tagging and naming resources"
}

variable "fs_service" {
  description = "Service that uses the AWS backups"
}

variable "prefix_name" {
  description = "Prefix to be used in the AWS backups naming"
}

variable "arn" {
  description = "EFS or RDS ARN for backup to be taken"
}

variable "backup_config" {
  description = "Map for taking backups of TeamCenter components (EFS,RDS) common to all environments"
  type        = object({
    enabled = bool
    cron_schedule = string
    retention_days = number
  })
}

