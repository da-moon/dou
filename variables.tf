variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "route_objects" {
  description = "A list of route objects"
  type        = any
  default     = []
}

variable "propagating_virtual_gateways" {
  description = "A list of virtual gateways for propagation."
  type        = list(string)
  default     = []
}

variable "assoc_gateway" {
  description = "A list of gateway IDs to create an association"
  type        = list(string)
  default     = []
}

variable "assoc_subnet" {
  description = "A list of subnet IDs to create an association"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of custom tags"
  type        = map(any)
  default     = {}
}
