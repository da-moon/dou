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
  default = ""
}

variable "kms_key_id" {
  description = "KMS key for encrypting the resulting AMI"
  type        = string
}

variable "tc_efs_id" {
  type = string
}
variable "machine_name" {
  description = "name of the host"
  type        = string
}
variable "samba_pass" {
  description = "samba password will be used for tc user "
  type        = string
  sensitive   = true
}
