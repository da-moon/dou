variable "region" {
  description = "Region used to build all objects"
  type        = string
  default     = ""
}

variable "ami" {
  description = "The ami to use for deploying vm"
  type        = string
  default     = ""
}

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

variable "source_path" {
  description = "Source path for user data script. This path should contain only until generic file with no extension since in the module it will append _rol.sh"
  type        = string
  default     = ""
}
variable "environment" {
  description = "tag for environment in which you will deploy th ec2"
  type        = string
  default     = "DEV"
}

variable "os" {
  description = "tag for OS your are using in the ec2"
  type        = string
  default     = "rhel 8"
}

variable "backend_bucket" {
  description = "backend s3 bucket to store the terraform state"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "key name for aws key pair resource to use in the ec2"
  type        = string
  default     = "eda_aws_key"
}

variable "vm_name"{
  description = "name for aws instance resource"
  type = string
  default = "eda"
}






