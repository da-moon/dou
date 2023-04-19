variable "name" {
  description = "The name of the bucket, should be FQDN."
  type        = string
}

variable "acl" {
  description = "The acl rule for the bucket. Options: private, public-read, public-read-write, aws-exec-read, authenticated-read, and log-delivery-write."
  type        = string
  default     = "private"
}

variable "policy" {
  description = "A valid bucket policy JSON document. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide."
  type        = string
  default     = null
}

variable "versioning" {
  description = "Whether to enable versioning on the bucket"
  type        = bool
  default     = false
}

variable "website_configuration" {
  description = "Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders."
  type        = map(any)
  default     = {}
}

variable "default_website_configuration" {
  description = "website_configuration default values"
  type = object({
    index_document    = string
    error_document    = string
    redirect_document = string
  })
  default = {
    index_document    = null
    error_document    = null
    redirect_document = null
  }
}

variable "sse_algorithm" {
  description = "The server-side encryption algorithm to use. Options: AES256 and aws:kms"
  type        = string
  default     = "AES256"
}

variable "kms_master_key_id" {
  description = "The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms."
  type        = string
  default     = null
}

variable "replication_configuration" {
  description = "website_configuration default values"
  type = object({
    iam_role_arn       = string
    replica_id         = string
    status             = string
    replica_bucket_arn = string
    storage_class      = string
  })
  default = {
    iam_role_arn       = null
    replica_id         = "replica"
    status             = "Enabled"
    replica_bucket_arn = null
    storage_class      = "STANDARD"
  }
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules to deploy"
  type = map(object({
    lifecycle_rule_prefix = string
    enabled               = bool
    transition = list(object({
      days          = number
      storage_class = string
    }))
    expiration = number
    noncurrent_version_transition = list(object({
      days          = number
      storage_class = string
    }))
    noncurrent_version_expiration = number
  }))
  default = {}
}

variable "tags" {
  description = "A mapping of custom tags"
  type        = map(any)
  default     = {}
}