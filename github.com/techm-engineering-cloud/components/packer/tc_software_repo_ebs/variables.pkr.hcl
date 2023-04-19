
variable "vpc_id" {
  description = "VPC used to launch the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet used to launch the EC2 instance"
  type        = string
}

variable "iam_instance_profile" {
  description = "Instance profile for the IAM role to be assumed by the EC2 instance"
  type        = string
}

variable "region" {
  description = "Region to launch the EC2"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key used to encrypt the software repo"
  type        = string
}

variable "base_ami" {
  description = "Base AMI used to launch the EC2 instance"
  type        = string
}

variable "source_s3_uri" {
  description = "S3 uri path of the source folder containing the files to copy to the software repo"
  type        = string
}

variable "build_uuid" {
  description = "Unique identifier for the EC2 instance"
  type        = string
}
