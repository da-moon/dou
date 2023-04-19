variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC. The default value makes your instances shared on the host. Other options (dedicated or host) costs at least $2/hr"
  type        = string
  default     = "default"
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
  type        = bool
  default     = false
}

variable "enable_classiclink" {
  description = "A boolean flag to enable/disable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic."
  type        = bool
  default     = false
}

variable "enable_classiclink_dns_support" {
  description = "A boolean flag to enable/disable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic."
  type        = bool
  default     = false
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block."
  type        = bool
  default     = false
}

#### SUBNET VARIABLES
variable "subnet_config" {
  description = "List of objects that will define the subnet. Required fields is 'cidr_block'."
  type        = any
  default     = []
}

#####
variable "securitygroup_config" {
  description = "List of objects that will define the security group."
  type        = any
  default     = []
}

variable "tags" {
  description = "A mapping of custom tags"
  type        = map(any)
  default     = {}
}