variable "region" {
  description = "The region in which to create the bucket"
}

variable "name_prefix" {
  description = "An additional prefix to distinguish the bucket"
  default     = ""
}
variable "name" {
  description = "The name of the bucket. Do not include deployment_type prefixes!"
}

variable "versioning" {
  description = "Whether to enable versioning on the bucket"
  default     = false
}

variable "acl" {
  description = "The acl rule for the bucket"
  default     = "private"
}

