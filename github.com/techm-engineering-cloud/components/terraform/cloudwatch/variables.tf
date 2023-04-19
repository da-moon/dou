variable "region" {
  type    = string
}

variable "dashboard_name" {
  description = "Name of the cloudwatch dashboard"
}

variable "env_name" {
  description = "Name of the environment monitored by this dashboard"
}

variable "sns_arn" {
  description = "ARN of SNS topic to use for alarms"
}

variable "installation_prefix" {
  description = "Prefix to use for all resources"
}

variable "web_hostname" {
  description = "DNS of the web servers"
}

variable "fsc_servers" {
  description = "DNS hostnames of FSC servers"
  type        = list(string)
}

variable "poolmgr_servers" {
  description = "DNS hostnames of pool manager servers"
  type        = list(string)
}

variable "license_server" {
  description = "License server hostname"
  type        = string
}

variable "db_server" {
  description = "Database hostname"
  type        = string
}

variable "awg_server" {
  description = "Active Workspace Gateway hostname"
  type        = string
}

variable "ms_server" {
  description = "Microservices load balancer endpoint"
  type        = string
}

variable "indexing_server" {
  description = "Indexing engine server"
  type        = string
}

