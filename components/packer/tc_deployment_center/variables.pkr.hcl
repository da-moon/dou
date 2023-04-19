
variable "installation_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  description = "Subnet to launch the temporal EC2 instance for Deployment Center"
  type        = string
}

variable "build_uuid" {
  type = string
}

variable "instance_profile" {
  description = "Instance profile for the role arn to assume"
  type        = string
}

variable "dc_efs_id" {
  type = string
}

variable "region" {
  type    = string
}

variable "base_ami" {
  type    = string
  default = ""
}

variable "kms_key_id" {
  description = "KMS key for encrypting the resulting AMI"
  type        = string
}

variable "dc_admin_user" {
  description = "User name for DeploymentCenter admin"
  type        = string
}

variable "dc_admin_pass_name" {
  description = "Name of the Secrets Manager secret containing the DeploymentCenter admin password"
  type        = string
}

variable "machine_name" {
  description = "Hostname of the build server"
  type        = string
}

variable "delete_data" {
  type    = bool
  default = false
}

variable "dc_folder_to_install" {
  description = "Name of the Deployment Center folder software to install"
  type        = string
}

variable "artifacts_bucket" {
  description = "s3 buckets to store artifacts"
}

variable "instance_type" {
  description = "EC2 instance type for Deployment Center"
  type        = string
}

variable "software_repo_snapshot" {
  description = "EBC snapshot ID of the software repository"
  type        = string
}

