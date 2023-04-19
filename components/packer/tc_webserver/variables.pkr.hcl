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

variable "webserver_instance_profile" {
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
  description = "Machine name (hostname) for the web server"
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

variable "tc_efs_id" {
  description = "EFS id for solr indexing specific vm"
  type        = string
}

variable "has_gateway" {
  description = "True if the AMI includes Active Workspace Gateway"
  type        = bool
}

variable "dns_suffix" {
  description = "Suffix to append to VPC hostnames to be resolvable from docker swarm network"
}

variable "ms_lb" {
  description = "DNS for microservice load balancer"
}

variable "fsc_servers" {
  description = "List of FSC servers"
  type        = list(string)
}

variable "web_internal_dns" {
  description = "Internal DNS for web server"
  type        = string
}
