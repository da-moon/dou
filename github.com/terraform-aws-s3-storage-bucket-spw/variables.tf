variable "name" {
  description = "The name of the bucket."
  type        = string
}

variable "versioning" {
  description = "Whether to enable versioning on the bucket"
  type        = bool
  default     = false
}

variable "acl" {
  description = "The acl rule for the bucket"
  type        = string
  default     = "private"
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

variable "policy" {
  description = "A valid bucket policy JSON document. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide."
  type        = string
  default     = null
}

variable "replica_flag" {
  description = "Flag to add the resources that need the replica_configuration block"
  type        = bool
  default     = false
}

variable "replication_configuration" {
  description = "website_configuration default values"
  type = object({
    replica_id    = string
    status        = string
    storage_class = string
  })
  default = {
    replica_id    = "replica"
    status        = "Enabled"
    storage_class = "STANDARD"
  }
}

variable "replica_name" {
  description = "The name of the replica bucket"
  type        = string
  default     = null
}

variable "replica_versioning" {
  description = "Whether to enable versioning on the bucket"
  type        = bool
  default     = false
}

variable "replica_acl" {
  description = "The acl rule for the replica of the bucket"
  type        = string
  default     = "private"
}

variable "bucket_replica_policy" {
  description = "A valid bucket policy JSON document for replica. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide."
  type        = string
  default     = null
}

variable "iam_policy" {
  description = "The policy document. This is a JSON formatted string."
  type        = string
  default     = null
}

variable "iam_role" {
  description = "Policy that grants an entity permission to assume the role."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of custom tags"
  type        = map(any)
  default     = {}
}
