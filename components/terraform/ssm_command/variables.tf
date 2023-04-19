
variable "instance_id" {
  description = "Identifier of the EC2 instance on which to run the command"
  type        = string
}

variable "commands" {
  description = "Commands to run"
  type        = list(string)
}

variable "region" {
  description = "Region where the instance is located"
  type        = string
}

variable "triggers" {
  description = "Run the command only any value of the given map changes"
  type        = map(string)
}
