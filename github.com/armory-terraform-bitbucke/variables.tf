variable "dockerhub_username" {
  type        = string
  description = "Docker Hub registry username"
}

variable "dockerhub_password" {
  type        = string
  sensitive   = true
  description = "Docker Hub registry password"
}

variable "domain" {
  type        = string
  description = "Domain name"
  default     = "ps-dou.com"
}

variable "environment" {
  type        = string
  description = "Environment where the app will be deployed"
  default     = "stg"
}

variable "bitbucket_version" {
  type        = string
  description = "Bitbucket version to deploy"
  default     = "7.21"
}