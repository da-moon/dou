variable "name" {
  description = "The name of the group. The name must consist of upper and lowercase alphanumeric characters with no spaces"
  type        = string
}

variable "path" {
  description = "Path in which to create the group."
  type        = string
  default     = "/"
}

variable "users" {
  description = "A list of IAM User names to associate with the Group"
  type        = list(string)
}