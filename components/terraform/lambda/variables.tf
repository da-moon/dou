
variable "function_name" {
  description = "Name of the function"
}

variable "code" {
  description = "Source code of the lambda function packaged as a zip file"
}

variable "code_hash" {
  description = "Hash of the zipped source code file"
}

variable "pipeline_name" {
  description = "Used to name the lambda function and associated resources"
}

variable "artifacts_bucket" {
  description = "S3 bucket name of pipeline artifacts"
  type        = string
}

variable "handler" {
  description = "Name of the file and function for the entry point of the lambda function."
  type        = string
}

variable "env_vars" {
  description = "Environment variables to use for the lambda function."
  type        = map(string)
  default     = {}
}
