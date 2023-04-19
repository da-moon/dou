variable "storage_capacity" {
  description = "The storage capacity (GiB) of the file system. Valid values between 64 and 524288"
  type        = number
  default     = 1024
}

variable "subnet_ids" {
  description = "An IDs for the subnet that the file system will be accessible from. Exactly 1 subnet need to be provided"
  type        = list(string)
  default     = []
}

variable "throughput_capacity" {
  description = "Throughput (megabytes per second) of the file system in power of 2 increments. Minimum of 64 and maximum of 4096"
  type        = number
  default     = 64
}

variable "security_group_ids" {
  description = "A list of IDs for the security groups that apply to the specified network interfaces created for file system access. These security groups will apply to all network interfaces."
  type        = list(string)
  default     = []
}
variable "fsx_name"{
  description = "namo for fsx file system"
  type = string
  default = "EDA file system"
}