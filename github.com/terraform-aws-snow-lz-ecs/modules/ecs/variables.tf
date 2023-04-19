# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# code: language=terraform insertSpaces=true tabSize=2
variable "project_name" {
  type        = string
  default     = "terraform-aws-snow-lz-ecs"
  description = "Project name"
}
variable "vpc_id" {
  type        = string
  description = <<EOT
  Application Load Balancer VPC ID
  EOT
}
variable "alb_sg_id" {
  type        = string
  description = <<EOT
  Application Load Balancer Security Group
  ID.
  EOT
}
variable "alb_target_group_id" {
  type        = string
  description = <<EOT
  ALB target group ID.
  EOT
}
variable "private_subnet_ids" {
  type        = list(string)
  description = <<EOT
  a list of private subnets in target VPC
  EOT
}

variable "docker_image" {
  type        = string
  default     = "fjolsvin/http-echo-rs"
  description = <<EOT
  Task's docker image
  EOT
}
# FIXME
variable "docker_image_tag" {
  type = string
  # validation {
  # condition     = can(regex("^\\d+\\.\\d+\\.\\d+$", var.docker_image_tag))
  # error_message = "The Docker image tag value must match the semantic versioning format: `0.0.0`."
  # }
  default     = "latest"
  description = <<EOT
  this variable holds the value of the specific tag of the Docker image
  that is getting used in the task.
  It is also used in task's name.
  AWS ECR repository policy ensures image tags are immutable so
  we cannot push an image with the same tag but different hash;
  For this reason, this variable does not have a default
  value (e.g 'latest') as it is imperative for a client of this module
  to manually pass in the tag.
  EOT
}
variable "memory_limit" {
  type        = number
  default     = 512
  description = <<EOT
  Fargate instance memory to provision (in MiB)
  EOT
}
variable "cpu_limit" {
  type        = number
  default     = 256
  description = <<EOT
  Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)
  EOT
}
variable "app_port" {
  type        = number
  default     = 5678
  description = <<EOT
  Port exposed by the docker image to redirect traffic to
  EOT
}
variable "app_count" {
  default     = 2
  description = <<EOT
  Number of docker containers to run
  EOT
}
locals {
  image = "${var.docker_image}:${var.docker_image_tag}"
}
