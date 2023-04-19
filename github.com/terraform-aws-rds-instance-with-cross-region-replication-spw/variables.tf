variable "db_size" {
  description = "# of GB in size to allocate to the database"
  default     = 20
}

variable "backup_retention_period" {
  description = "# of days to maintain a rolling backup for this database"
  default     = 30
}

variable "name" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier."
}

variable "engine_version" {
  description = "The engine version to use for the DB"
  default     = "9.6"
}

variable "instance_type" {
  description = "Instance type to be started"
}

variable "engine_type" {
  description = "Engine type, postgres, mysql, maria db, etc."
  # default = "dr"
}

variable "master_user" {
  description = "Username of master DB user"
}

variable "master_password" {
  description = "Password of master DB user"
}

variable "db_parameter_group" {
  description = "Db parameter group to use"
}

variable "db_multi_az" {
  description = "true/false, dictates across how many availability zones this DB should be replicated"
  default     = "false"
}

variable "run_env" {
  description = "run environment (devops/dev/sand/qa/stage/prep/prod)"
}

variable "db_subnet_ids" {
  description = "Subnet ids for group name."
}

variable "cross_region_replica_subnet_ids" {
  description = "Subnet ids for prod DR group name."
}

variable "vpc_id" {
  description = "ID of VPC to provision database in"
}

variable "db_security_groups" {
  description = "List of database security group ids"
}

variable "route53_zone_id" {
  description = "AWS Hosted Zone Id"
}

variable "storage_encryption" {
  description = "Storage encryption"
  default     = "true"
}

variable "snapshot_id" {
  description = "Snapshot ID"
}

variable "initial_database" {
  default = ""
}

variable "enhanced_monitoring" {
  
}

# variable "monitor_interval" {
#   default = "60"
# }

# variable "create_cross_region_replica" {
#   description = "Indicate whether or not to create cross-region RDS read replica"
#   default     = "false"
# }
#
# variable "cross_region_subnet_ids" {
#   description = "Subnet ids for cross region group name."
# }

# variable "replica_identifier" {
#   description = "identifier"
# }

# variable "replica_instance_class" {
#   description = "replica_instance_class"
# }
#
# variable "replica_storage_encrypted" {
#   description = "replica_storage_encrypted"
# }
#
# variable "replica_zone_id" {
#   description = "replica_zone_id"
# }
#
# variable "replica_type" {
#   description = "replica_type"
# }
#
# variable "replica_ttl" {
#   description = "replica_ttl"
# }
#
# variable "replica_records" {
#   description = "replica_records"
# }
#
# variable "replica_create_read_replica" {
#   description = "replica_create_read_replica"
# }
