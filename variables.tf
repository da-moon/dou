# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# code: language=terraform insertSpaces=true tabSize=2

#
# ──── DOCKER PROVIDER ────────────────────────────────────────────────
#
variable "docker_host" {
  type        = string
  default     = "unix:///var/run/docker.sock"
  description = <<EOF
  target Docker daemon host.
  Defaults to local docker unix socket.
  EOF
}
variable "src_registry_url" {
  type        = string
  default     = "registry.hub.docker.com"
  description = "Source docker image registry root URL"
}
variable "src_registry_username" {
  type        = string
  description = "Source container registry username."
}
variable "src_registry_password" {
  type        = string
  description = "Source container registry password"
  sensitive   = true
}
#
# ──── AWS PROVIDER ──────────────────────────────────────────────────
#
variable "aws_region" {
  type        = string
  description = <<EOF
  AWS deployment region.
  this variable is added without a default value for forcing this
  module clients to pass in this value and prevent sourcing from
  'AWS_DEFAULT_REGION' environment variable.
  EOF
}
variable "aws_access_key" {
  type        = string
  sensitive   = true
  description = <<EOF
  AWS access key.
  this variable is added without a default value for forcing this
  module clients to pass in this value and prevent sourcing from
  'AWS_ACCESS_KEY_ID' environment variable.
  EOF
}
variable "aws_secret_key" {
  type        = string
  sensitive   = true
  description = <<EOF
  AWS secret key.
  this variable is added without a default value for forcing this
  module clients to pass in this value and prevent sourcing from
  'AWS_SECRET_ACCESS_KEY' environment variable.
  EOF
}
variable "aws_token" {
  type        = string
  sensitive   = true
  description = <<EOF
  AWS session token key.
  this variable is added without a default value for forcing this
  module clients to pass in this value and prevent sourcing from
  'AWS_SESSION_TOKEN' environment variable.
  EOF
}
#
# ──── SHARED VARIABLES ──────────────────────────────────────────────
#
variable "project_name" {
  type        = string
  default     = "terraform-aws-snow-lz-ecs"
  description = "Project name"
}
variable "environment" {
  type        = string
  default     = "npe"
  description = "Deployment Environment"
}
#
# ──── VPC MODULE ────────────────────────────────────────────────────
#
variable "availablity_zone_count" {
  type        = number
  default     = 2
  description = "Number of AZs to cover in a given AWS region"
}
variable "cidr_block" {
  type        = string
  default     = "172.17.0.0/16"
  description = "VPC cidr"
}
#
# ──── ALB MODULE ────────────────────────────────────────────────────
#
variable "alb_ingress_cidr" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = <<EOF
  Accepted Application Load balancer ingerss CIDR range.
  Modify this to restrict access to application as
  all incoming traffic must pass through the ALB
  EOF
}
variable "health_check_path" {
  type        = string
  default     = "/health"
  description = <<EOF
  Health check path of deamon running inside the Docker container
  managed by ECS.
  EOF
}
#
# ──── ECS MODULE ────────────────────────────────────────────────────
#
variable "fargate_memory_limit" {
  type        = number
  default     = 512
  description = "Fargate instance memory to provision (in MiB)"
}
variable "fargate_cpu_limit" {
  type        = number
  default     = 256
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
}
variable "app_port" {
  type        = number
  default     = 5678
  description = "Port exposed by the docker image to redirect traffic to"
}
variable "app_count" {
  type        = number
  default     = 2
  description = "Number of docker containers to run"
}
variable "deployment_image_tag" {
  type        = string
  default     = "latest"
  description = <<EOF
  image tag used in deployment
  EOF
}
#
# ──── ECR MODULE ────────────────────────────────────────────────────
#
variable "src_docker_image_name" {
  type        = string
  default     = "fjolsvin/http-echo-rs"
  description = "Source repository Docker image name (without tag)"
}
variable "src_docker_image_tags" {
  type        = list(string)
  default     = ["latest"]
  description = <<EOF
  Source docker image tags
  EOF
}
variable "ecr_lifecyle_policy_image_count" {
  type        = number
  default     = 3
  description = "Maximum number of images to keep in the registry"
}
