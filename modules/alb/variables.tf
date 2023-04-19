# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# code: language=terraform insertSpaces=true tabSize=2
variable "project_name" {
  type        = string
  default     = "terraform-aws-snow-lz-ecs"
  description = "Project name"
}
variable "vpc_id" {
  type        = string
  description = <<EOF
  Application Load Balancer VPC ID
  EOF
}
variable "ingress_cidr" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = <<EOF
  Accepted Application Load balancer ingerss CIDR range.
  Modify this to restrict access to application as
  all incoming traffic must pass through the ALB
  EOF
}
variable "public_subnet_ids" {
  type        = list(string)
  description = <<EOF
  Public Subnet IDs in the VPC to attach to the ALB
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
