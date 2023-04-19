variable "region" {
  type = string
  default = "West Central US"
}

variable "rs_name" {
    type = string
    default = "fis"
}

variable "az_client_secret" {
    type = string
    sensitive = true
}

variable "az_service_principal" {
  type = string
}

variable "app_insights_region" {
  type = string
  default = "southcentralus"
}

variable "digital_twins_users" {
  type = list
  default = ["antonio.cabrera@digitalonus.com", "rodrigo.valdes@digitalonus.com", "leonel.perea@digitalonus.com", "edgar.lopez@digitalonus.com"] 
}

variable "external_users" {
  type = list
  default = ["atul.mehta1_techmahindra.com#EXT#@digitalonus01.onmicrosoft.com"] 
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "eventhub_tier" {
  type = string
}

variable "iot_hub_tier" {
  type = string
}

variable "iot_hub_capacity" {
  type = string
}

variable "grafana_auth" {
  type = string
}
