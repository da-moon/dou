
variable "pipeline_name" {
  description = "Name to use for the pipeline"
  type        = string
}

variable "repo_name" {
  description = "Name of the repository hosting the source code"
  type        = string
}

variable "artifacts_bucket" {
  description = "S3 bucket name of pipeline artifacts"
  type        = string
}

variable "build_stages" {
  description = "Map of build stages to provion, with key: stage name and value: CodeBuild project name"
  type      = list(object({
    name    = string,
    actions = list(object({
      name          = string
      category      = string
      provider      = string
      configuration = map(string)
      run_order     = number
    }))
  }))
}

variable "polling_enabled" {
  description = "polling - to trigger on code changes (Default: true)"
  default = true
}

