variable "region" {
  description = "The DO region for droplets"
  default     = "nyc1"
}

variable "droplet_size" {
    description = "Droplet size to use"
    default = "s-1vcpu-2gb"
}
