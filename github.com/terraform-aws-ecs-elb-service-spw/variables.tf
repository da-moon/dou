variable "cluster_id" {
  description = "The name of the cluster on which to run this service"
}

variable "container_definitions" {
  description = "A json array of container definitions"
}

variable "container_name" {
  description = "Name of the container for the ELB"
}

variable "container_port" {
  description = "Port of the container for the ELB"
}

variable "desired_count" {
  description = "The desired number of service container groups to run on the cluster"
}

variable "elb_name" {
  description = "The name of the ELB to associate with the service"
}

variable "name" {
  description = "The name of the service and task definition"
}

variable "service_iam_role" {
  description = "IAM role for the service to register load balancer containers"
}

variable "task_iam_role" {
  description = "IAM role for the task to run under"
}

