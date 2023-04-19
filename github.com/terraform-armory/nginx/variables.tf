variable "registry_server" {
  type    = string
  default = "docker.io"
}

variable "registry_username" {
  type    = string
  default = "abrahamgarciav"
}

variable "registry_password" {
  type      = string
  sensitive = true
  default   = "9ab45f66-f4a8-45ac-bff3-dbb298a298b6"
}

variable "domain" {
  type    = string
  default = "ps-dou.com"
}

variable "environment" {
  type    = string
  default = "stg"
}