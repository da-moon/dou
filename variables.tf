variable "region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment"
}

variable "cluster_version" {
  type        = string
  default     = "1.20"
  description = "EKS Cluster version"
}

variable "instance_type" {
  type        = string
  default     = "t3.2xlarge" # 8vCPU - 32GiB Memory
  description = "EKS Worker instance type"
}

variable "desired_capacity" {
  type        = number
  default     = 3
  description = "EKS worker auto scalling group desired capacity"
}

variable "max_size" {
  type        = number
  default     = 3
  description = "EKS worker auto scalling group max size"
}

variable "min_size" {
  type        = number
  default     = 1
  description = "EKS worker auto scalling group min size"
}

variable "db_user" {
  type        = string
  description = "Username for the master DB user"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "Password for the master DB user"
  sensitive   = true
}

variable "base_dns_name" {
  type        = string
  default     = "ps-dou.com"
  description = "DNS Zone name"
}

variable "subdomains" {
  type        = list(string)
  default     = ["dev", "stg"]
  description = ""
}

variable "deck_ingress_names" {
  type = map(string)
  default = {
    "stg" = "a235c9acb2b4d40d5a8d880abb6aac12"
  }
  description = ""
}

variable "gate_ingress_names" {
  type = map(string)
  default = {
    "stg" = "a718a4c9e7f714467b6a14e52feb95a1"
  }
  description = ""
}