variable "cluster_id" {
  description = "The name of the cluster on which to run this service"
}

variable "container_definitions" {
  description = "A json array of container definitions"
}

variable "desired_count" {
  description = "The desired number of service container groups to run on the cluster"
}

variable "name" {
  description = "The name of the service and task definition"
}

variable "task_iam_role" {
  description = "IAM role for the task to run under"
}

