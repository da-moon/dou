variable "lambda_bucket_id" {
}

variable "lambda_s3_key" {
}

variable "lambda_function_name" {
  description = "Function name in s3 bucket"
}

variable "file_name" {
}

variable "runtime_env" {
  default     = "python2.6"
  description = "Code of python"
}

variable "lambda_description" {
  default = "AWS lambda code"
}

variable "source_code_hash" {
  description = "SHAHash of lambda code"
}

variable "subnet_ids" {
  description = "Subnet id comma separated as string"
}

variable "lambda_securitygroup" {
}

variable "run_env" {
}

variable "schedule_name" {
}


variable "timeout_sec" {
  default = 3
}

variable "lambda_service_policy_name" {
  default = ""
}

variable "lambda_iam_role" {
  default = "Iam role for lambda"
}

variable "default_region" {
  default = "us-east-1"
}

variable "lambda_vars" {
  type = map(string)
}

variable "log_retain_days" {
  default = "14"
}

variable "memory_size" {
  default = "128"
}

variable "lambda_arn_push_es" {
  description = "Lambda job arn which pushes logs to ES"
}

variable "lambda_count" {
  default = "1"
}

variable "asg_name" {
  type = list(string)
}

variable "detail_type" {
  type = list(string)
}
