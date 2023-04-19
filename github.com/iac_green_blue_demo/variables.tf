variable "private_key_path" {
  description = "Path to the key ssh name"
}

variable "key_name" {
  description = "SSH key name"
}

variable "personal_dns" {
  description = "Set to true if you want to provide domain name"
  default     = false
}

variable "route53_zone_id" {
  description = "The zone id from route 53"
  default     = false
}

variable "domain_name" {
  description = "The domain name"
  default     = false
}
