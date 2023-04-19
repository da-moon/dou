
variable "repo_name" {
  description = "Name of the git repository that will host all the infrastructure as code"
  type        = string
}

variable "region" {
  description = "AWS region where the repository is hosted"
  type        = string
}

