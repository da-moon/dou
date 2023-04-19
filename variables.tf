#########################
#  Multi-Use Variables  #
#########################
variable "run_env" {
  description = "Run environment (dev/qa/stage/prod)"
}

# Cluster Details
variable "cluster_ami" {
  description = "AMI for ECS container instance"
  default     = "ami-ec346f96"
}

variable "cluster_min_hosts" {
  description = "Desired min number of hosts in the cluster"
  default     = 3
}

variable "cluster_max_hosts" {
  description = "Desired max number of hosts in the cluster"
  default     = 20
}

variable "cluster_name" {
  description = "Name of the cluster"
}

variable "cluster_so_max_conn" {
  description = "Override the default setting for net.core.somaxconn on the ecs cluster hosts."
  default     = "4096"
}

variable "default_region" {
  description = "The region for the AWS provider"
  default     = "us-east-1"
}

variable "deploy_key_pair" {
  description = "Key pair used on EC2 instances"
}

variable "instance_type" {
  description = "Instance type for the cluster"
  default     = "c4.large"
}

variable "ecs_cluster_asg_cpu_utilization_threshold" {
  description = "Do NOT adjust if you don't understand, in detail, how this works. Adjusts the threshold of the alarm for the cpu utilization metric for the asg which drives autoscaling for the ECS cluster "
  default     = "95"
}

variable "ecs_cluster_cpu_utilization_threshold" {
  description = "Do NOT adjust if you don't understand, in detail, how this works. Adjusts the threshold of the alarm for the cpu utilization metric which drives autoscaling for the ECS cluster "
  default     = "95"
}

variable "ecs_cluster_memory_utilization_threshold" {
  description = "Do NOT adjust if you don't understand, in detail, how this works. Adjusts the threshold of the alarm for the memory metric which drives autoscaling for the ECS cluster "
  default     = "90"
}

variable "ecs_engine_auth_type" {
  description = "This is the type of authentication data in ECS_ENGINE_AUTH_DATA: dockercfg or docker. *** If you wish to use ECR then do not overwrite the default. Overwrite this for use with other private container repos ***"
  default     = ""
}

variable "ecs_engine_auth_data" {
  description = "If 'ecs_engine_auth_type' is set to 'docker' then this variable should be a JSON structure like: {'username:my_username','password:my_password','email:my_email@example.com'}. If it is set to 'dockercfg' then this variable should be like the contents of a Docker configuration file created by running 'docker login'"
  default     = ""
}

variable "cluster_security_groups" {
  description = "Security groups to be applied to the cluster: comma separated list"
}

variable "cluster_subnet_ids" {
  description = "Subnets to launch the cluster across: comma separated list"
}

variable "cluster_ecs_instance_profile_id" {
  description = "IAM Profile to attach to started instances"
}

# Init Variables
variable "consul_agent_version" {
  description = "Version of the Consul agent to run"
}

variable "consul_client_key" {
  description = "The Consul cluster encryption key"
}

variable "consul_host" {
  description = "URL of the Consul host (no trailing slash)"
}

variable "consul_dns_ip" {
  description = "DNS Ip for consul configuration"
}

variable "logging_host" {
  description = "URL of the Logstash host (no trailing slash)"
}

