variable "installation_prefix" {
  type = string
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
  type = string
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

variable "machine_name" {
  description = "name of the host"
  type        = string
}

variable "install_scripts_path" {
  description = "Path in the CI/CD S3 bucket of TeamCenter installation scripts to use"
  type        = string
}

variable "dc_user_secret_name" {
  description = "Secrets Manager secret name containing the Deployment Center user"
  type        = string
}

variable "dc_pass_secret_name" {
  description = "Secrets Manager secret name containing the Deployment Center password"
  type        = string
}

variable "dc_url" {
  description = "Load balancer url for Deployment Center"
  type        = string
}

variable "ignore_tc_errors" {
  description = "If true the installation errors that can happen when team center is not installed on purpose will be ignored"
  type        = bool
}

variable "stage_name" {
  description = "Name of the stage/action invoking this template. Used to save logs to the right S3 bucket path."
  type        = string
}

variable "file_repo_path" {
  description = "Path of the file repository used by the microservices"
}

variable "is_manager" {
  description = "Indicates if the AMI is being built for a microservice manager node"
  type        = bool
}

variable "ecr_registry" {
  description = "ECR Registry."
  type        = string
}

variable "keystore_secret_name" {
  description = "Secret name in Secrets Manager of microservice keystore password"
  type        = string
}
