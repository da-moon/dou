# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# code: language=terraform insertSpaces=true tabSize=2
#
variable "availablity_zone_count" {
  type        = number
  default     = 2
  description = <<EOT
  Number of AZs to cover in a given AWS region"
  EOT
}
variable "project_name" {
  type        = string
  default     = "terraform-aws-snow-lz-ecs"
  description = "Project name"
}
variable "cidr_block" {
  type        = string
  default     = "172.17.0.0/16"
  description = "VPC cidr"
}
