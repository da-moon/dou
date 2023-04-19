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

variable "software_repo_snapshot" {
  description = "ID of the EBS snapshot containing the software repository"
  type        = string
}

