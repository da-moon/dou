variable "vpc_id" {
  description = "The VPC ID."
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the subnet."
  type        = string
}

variable "ipv6_cidr_block" {
  description = "The IPv6 network range for the subnet, in CIDR notation. The subnet size must use a /64 prefix length."
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "The AZ for the subnet."
  type        = string
  default     = null
}

variable "availability_zone_id" {
  description = "The AZ ID for the subnet."
  type        = string
  default     = null
}

variable "assign_ipv6_address_on_creation" {
  description = "Allow network interfaces created in the specified subnet should be assigned an IPv6 address."
  type        = bool
  default     = false
}

variable "allow_public_ip" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address."
  type        = bool
  default     = false
}

# variable "customer_owned_ip" {
#   description = "Specify true to indicate that network interfaces created in the subnet should be assigned a customer owned IP address. The <<customer_owned_ipv4_pool>> and <<outpost_arn>> arguments must be specified when set to true."
#   type        = bool
#   default     = false
# }

# variable "customer_owned_ipv4_pool" {
#   description = "The customer owned IPv4 address pool. The <<customer_owned_ip>> and <<outpost_arn>> arguments must be specified when configured."
#   type        = string
#   default     = null
# }

# variable "outpost_arn" {
#   description = "The Amazon Resource Name (ARN) of the Outpost."
#   type        = string
#   default     = null
# }

variable "tags" {
  description = "A mapping of custom tags"
  type        = map(any)
  default     = {}
}