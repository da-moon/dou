variable "public_key" {
  description = "Public key for ssh to be copied to ec2"
  type        = string
  default     = ""
}

variable "priv_key" {
  description = "private key to connect to ec2"
  type        = string
  default     = ""
}

variable "ami" {
  description = "The ami to use for deploying vm"
  type        = string
  default     = ""
}

variable "priv_subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = null
}

variable "pub_subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = null
}

variable "security_group" {
  description = "security group of the ec2 instance"
  type        = string
  default     = ""
}

variable "user_data" {
  description = "source path for requeriments installation script"
  type        = string
  default     = ""
}

variable "source_path" {
  description = "Source path for user data script. This path should contain only until generic file with no extension since in the module it will append _rol.sh"
  type        = string
  default     = ""
}

variable "environment" {
  description = "environment in which you will deploy th ec2"
  type        = string
  default     = ""
}

variable "region" {
  description = "Region used to build all objects"
  type        = string
  default     = ""
}

variable "os" {
  description = "OS your are using in the ec2"
  type        = string
  default     = ""
}

variable "fsx_dns" {
  description = "DNS name"
  type        = string
  default     = ""
}

variable "iam_instance_profile_master" {
  description = "IAM role to attach to master"
  type        = string
  default     = ""
}

variable "iam_instance_profile_server" {
  description = "IAM role to attach not master instances"
  type        = string
  default     = ""
}

variable "key_name"{
  description = "key name for aws key pair resource to use in the ec2"
  type = string
  default = "eda_aws_key"
}

variable "vm_name"{
  description = "name for aws instance resource"
  type = string
  default = "eda"
}