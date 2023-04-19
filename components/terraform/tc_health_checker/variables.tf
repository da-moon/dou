
variable "installation_prefix" {
  description = "Prefix to use for naming resources"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnets where the lambda function will be available"
  type        = list(string)
}
