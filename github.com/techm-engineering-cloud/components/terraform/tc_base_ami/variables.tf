
variable "artifacts_bucket_name" {
  description = "S3 bucket name for CI/CD automation, where pipeline artifacts are stored"
  type        = string
}

variable "force_rebake" {
  description = "If true, packer will run even if there are any changes."
  type        = bool
}

