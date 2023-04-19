variable "region" {
  description = "The region in which to create the bucket"
}

variable "name" {
  description = "The name of the bucket, should be FQDN."
}

variable "versioning" {
  description = "Whether to enable versioning on the bucket"
  default     = false
}

variable "acl" {
  description = "The acl rule for the bucket"
  default     = "private"
}

variable "name_prefix" {
  description = "An additional prefix to distinguish the bucket"
  default     = ""
}

variable "cidr1" {
  description = "Allow IP Ranges for website"
  default     = "10.101.0.0/16"
}

variable "cidr2" {
  description = "Allow IP Ranges for website"
  default     = "10.103.0.0/16"
}

variable "cidr3" {
  description = "Allow IP Ranges for website"
  default     = "10.122.0.0/23"
}

variable "cidr4" {
  description = "Allow IP Ranges for website"
  default     = "10.124.0.0/23"
}

variable "cidr5" {
  description = "Allow IP Ranges for website"
  default     = "10.155.1.0/24"
}

variable "cidr6" {
  description = "Allow IP Ranges for website"
  default     = "10.123.0.0/23"
}

variable "check" {
  description = "conditional to be used the the count parameter"
}
