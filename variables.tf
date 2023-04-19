variable "bucket_name" {
  description = "Name of the bucket for notification configuration."
  type        = string
}

variable "eventbridge" {
  description = "Whether to enable Amazon EventBridge notifications."
  type        = bool
  default     = null
}

variable "lambda_function" {
  description = "Used to configure notifications to a Lambda Function."
  type        = list(any)
  default     = []
}

variable "queue" {
  description = "Notification configuration to SQS Queue."
  type        = list(any)
  default     = []
}

variable "topic" {
  description = "Notification configuration to SNS Topic."
  type        = list(any)
  default     = []
}
