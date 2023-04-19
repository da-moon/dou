#======== VPC ========
variable "vpc_name" {
  description = "VPC where servers will reside"
  type        = string
  default     = "vpc-0000000000000000e"
}
variable "azs" {
  description = "Availability zone"
  type        = list(string)
  default     = ["us-west-1a"]
}
variable "cidr" {
  description = "range of ip addr"
  type        = string
  default     = ""
}
variable "priv_sub" {
  description = "private subnets"
  type        = list(string)
  default     = []
}

variable "pub_sub" {
  description = "public subnets"
  type        = list(string)
  default     = []
}

variable "gateway" {
  description = "nat gateway to be created"
  type        = bool
  default     = true
}

#======== S3 Bucket ========

variable "create" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = true
}

variable "bucket" {
  description = "The name of the bucket to put the file in. Alternatively, an S3 access point ARN can be specified."
  type        = string
  default     = ""
}
variable "acl" {
  description = "The canned ACL to apply. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, bucket-owner-read, and bucket-owner-full-control. Defaults to private."
  type        = string
  default     = ""
}

#======== FSX ========

variable "storage_capacity" {
  description = "The storage capacity (GiB) of the file system. Valid values between 64 and 524288"
  type        = number
  default     = 1024
}

variable "throughput_capacity" {
  description = "Throughput (megabytes per second) of the file system in power of 2 increments. Minimum of 64 and maximum of 4096"
  type        = number
  default     = 64
}
variable "region" {
  description = "Region used to build all objects"
  type        = string
  default     = ""
}
variable "fsx_name" {
  description = "namo for fsx file system"
  type        = string
  default     = "EDA file system"
}
variable "iam_role" {
  description = "Name for IAM role"
  type        = string
  default     = "eda-ec2-role-2"
}
variable "iam_instance_profile" {
  description = "Name for IAM instance profile resource"
  type        = string
  default     = "eda-ec2-role-2"
}

variable "iam_role_policy" {
  description = "Name for IAM role policy resource"
  type        = string
  default     = "eda-ec2-role-policy-2"
}
variable "security_group_name" {
  description = "name for the security group"
  type        = string
  default     = "securityGroupLSF"
}