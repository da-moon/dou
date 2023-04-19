# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# code: language=terraform insertSpaces=true tabSize=2

#
# ──── COMMON ────────────────────────────────────────────────────────
#

variable "project_name" {
  type        = string
  default     = "terraform-aws-snow-lz-ecs"
  description = "Project name"
}

#
# ──── DOCKER IMAGE IN SOURCE REPO ────────────────────────────────────
#
variable "docker_image_name" {
  type        = string
  default     = "fjolsvin/http-echo-rs"
  description = "Source repository Docker image name (without tag)"
}
variable "docker_image_tags" {
  type        = list(string)
  default     = ["latest"]
  description = <<EOF
    this variable holds the value of the specific tag of the Docker image
    that is getting pushed to ECR Repository.
    AWS ECR repository policy ensures image tags are immutable so
    we cannot push an image with the same tag but different hash;
    For this reason, this variable does not have a default
    value (e.g 'latest') as it is imperative for a client of this module
    to manually pass in the tag.
  EOF
}
#
# ──── ELASTIC CONTAINER REGISTRY ────────────────────────────────────
#
variable "lifecyle_policy_image_count" {
  type        = number
  default     = 3
  description = "Maximum number of images to keep in the registry"
}
