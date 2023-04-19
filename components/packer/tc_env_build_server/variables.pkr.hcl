
variable "installation_prefix" {
  description = "Prefix to use for all installation components"
  type        = string
}

variable "env_name" {
  description = "Name of the teamcenter environment"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the build server"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "build_uuid" {
  type = string
}

variable "instance_profile" {
  description = "Instance profile associated to the IAM role to be used by the build server"
  type        = string
}

variable "tc_efs_id" {
  type = string
}

variable "region" {
  type    = string
}

variable "base_ami" {
  type    = string
}

variable "kms_key_id" {
  description = "KMS key for encrypting the resulting AMI"
  type        = string
}

variable "machine_name" {
  description = "name of the host"
  type        = string
}

variable "deploy_scripts_s3_bucket" {
  description = "Name of the S3 bucket where the deployment scripts are stored"
  type        = string
}

variable "dc_url" {
  description = "Load balancer url for Deployment Center"
  type        = string
}

variable "private_hosted_zone_name" {
  description = "private hosted zone name"
}

variable "private_hosted_zone_arn" {
  description = "private hosted zone arn"
}

variable "sm_db_name" {
  description = "Name of the Server Manager tablespace"
  type        = string
}

variable "sm_db_user_name" {
  description = "Name of the Secrets Manager secret for the database Server Manager user name"
  type        = string
}

variable "sm_db_pass_name" {
  description = "Name of the Secrets Manager secret for the database Server Manager password"
  type        = string
}

variable "db_admin_user_name" {
  description = "Name of the Secrets Manager secret for the database user name"
  type        = string
}

variable "db_admin_pass_name" {
  description = "Name of the Secrets Manager secret for the database password"
  type        = string
}

variable "infodba_user_name" {
  description = "Name of the Secrets Manager secret for the infodba user name"
  type        = string
}

variable "infodba_pass_name" {
  description = "Name of the Secrets Manager secret for the infodba password"
  type        = string
}

variable "db_host" {
  description = "Hostname of the database"
  type        = string
}

variable "db_sid" {
  description = "Oracle SID for establishing the connection"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace to use, if available"
  type        = string
}

variable "keystore_secret_name" {
  description = "Secret name in Secrets Manager of microservice keystore password"
  type        = string
}
