#### EKS
variable "cluster-name" {}
variable "desired_capacity" {}
variable "max_size" {}
variable "min_size" {}


### Project 
variable "project_name" {}
variable "domain" {}


#### VPC/Network Config
variable "cidr_block" {}
variable "azs_public" {}
variable "azs_private" {}
variable "azs_publics" {}
variable "azs_privates" {}
variable "private_subnets" {}
variable "public_subnets" {}
variable "public_subnets_name" {}
variable "private_subnets_name" {}

variable "instance_type" {}


##################
# RDS ##
########

variable "name" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier."
}

variable "db_name" {}

variable "db_size" {
  description = "# of GB in size to allocate to the database"
}

variable "max_db_size" {
  description = "# of GB in size to allocate to the database"
}

variable "backup_retention_period" {
  description = "# of days to maintain a rolling backup for this database"
}

variable "storage_type" {}
variable "instance_class" {}

variable "engine_type" {
  description = "Engine type, postgres, mysql, maria db, etc."
}

variable "engine_version" {
  description = "The engine version to use for the DB"
}

variable "master_user" {
  description = "Username of master DB user"
}

variable "master_password" {
  description = "Password of master DB user"
}

variable "db_multi_az" {
  description = "true/false, dictates across how many availability zones this DB should be replicated"
}

variable "run_env" {
  description = "run environment (devops/dev/sand/qa/stage/prep/prod)"
}

variable "db_subnet_ids" {
  description = "Subnet ids for group name."
}

variable "enhanced_monitoring" {
  description = "The enhanced monitoring role arn for databases"
}

variable "initial_database" {}
variable "monitor_interval" {}


//NSG
variable "nsg_rule" {
  type        = list(list(string))
  description = "Security Group Description and Port"
}


