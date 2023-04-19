variable "gpc_project_name" {
  default = "waas-demo"
}

variable "region" {
  default = "us-west2"
}

variable "namespaces" {
  default = [
    "shared-services"
  ]
}

variable "nginx_tpl_values" {
  default = {}
}

variable "vault_tpl_values" {
  default = {}
}
variable "consul_tpl_values" {
  default = {}
}

variable "proxy_pass" {
  default = ""
}

variable "proxy_user" {
  default = "admin"
}