
variable "subnet_id" {
  description = "Subnet where the EC2 instance should be launched"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key to use to encrypt the software repo volume"
  type        = string
}

variable "source_s3_uri" {
  description = "S3 uri path of the source folder containing the files to copy to the software repo"
  type        = string
}

variable "force_rebake" {
  description = "Indicates if packer should run even if there are no changes"
  type        = bool
}

