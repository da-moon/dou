#### Project Config
variable "project_name" {}

#### AWS Config
variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}
variable "aws_profile" {}
variable "aws_region" {}

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

# A tenancy option for instances launched into the VPC.
# Default is default, which makes your instances shared on the host.
# Using either of the other options (dedicated or host) costs at least $2/hr.
variable "instance_tenancy" {}

## Bastian Host Config
## NOTE: If you change the ami it is possible the user will change, i.e make sure to update the default `user` variable to reflect your change.
variable "ami" {}
variable "ssh_user" {}
variable "instance_type" {}

# ECR
variable "ecr_user_arn" {}


########################
#   VARIABLES FOR TF CLOUD   #
########################

variable "container_image" {}
variable "container_port" {}
variable "health_check_path" {}


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

# variable "storage_encryption" {
#   description = "Storage encryption"
#   default     = "true"
# }

variable "enhanced_monitoring" {
  description = "The enhanced monitoring role arn for databases"
}

variable "initial_database" {}
variable "monitor_interval" {}
variable "domain" {}

###########
##cluster#
###########

variable "cluster-name" {}
