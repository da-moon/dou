
variable "prefix_name" {
  description = "Prefix to use for all created resources"
  default     = ""
}

variable "repo_url" {
  description = "Name of the repository hosting the source code"
  type        = string
}

variable "repo_type" {
  description = "Type of repository that contains the source code to be built. Valid values: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, BITBUCKET, S3, NO_SOURCE"
}

variable "build_stages" {
  description = "Stages that run buildspec.yml files"
  type = list(object({
    stage_name = string,
    build_spec = string,
    env_vars   = map(string)
  }))
}

variable "artifacts_bucket" {
  description = "S3 bucket name where pipeline artifacts are stored"
  type        = string
}

variable "codebuild_image" {
  description = "Docker image used to run codebuild projects"
  type        = string
}

