# Group requirements
variable "gitlab_group_name" {
  description = "Group name"
}

variable "gitlab_access_level" {
  description = "Gitlab Access Level"
}
variable "gitlab_members" {
  description = "Gitlab members"
  default     = []
}
