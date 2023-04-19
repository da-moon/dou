
variable "env_name" {
  description = "Name of the environment, used for tagging and naming resources"
}

variable "zone" {
  description = "Root zone for domain names. Example: acme.com"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "region" {
  description = "AWS region"
}

