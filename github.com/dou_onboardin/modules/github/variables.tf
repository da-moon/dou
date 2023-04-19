variable "github_team" {
  type        = string
  description = "DigitalOnUs managed team"
}

variable "github_members" {
  description = "DigitalOnUs managed team members"
  type        = list(any)
  default     = []
}

variable "github_maintainers" {
  description = "DigitalOnUs managed team maintainers"
  type        = list(any)
  default     = []
}