###################
# Required values #
###################
variable network_address_space {
  default = { Development = "10.10.11.0/24" }
  #default = {Dev = "10.3.0.0/24"}
}

variable "service_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "lb_ports" {
  type = list(number)
}

variable "service_ports" {
  type = list(number)
}

variable "lb_listener_ports" {
  type = list(number)
}

variable "ami_name" {
  type    = string
  default = "consul-"
}

variable "subnet_count" {
  type = map(number)
}

variable "private_key_path" {
  default = "./caas-dev.pem"
}

variable "key_name" {
  default = "caas-dev"
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "service_template_file" {
  type = string
}

variable "service_template_name" {
  type = string
}

###################
# Optional values #
###################
variable "service_template_vars" {
  default = null
}

variable "ami_root_device_type" {
  default = "ebs"
}

variable "ami_virtualization_type" {
  default = "hvm"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_key_name" {
  type = string
}

variable "environment" {
  default = "Dev"
}

variable "asg_min_size" {
  default = 1
}

variable "asg_max_size" {
  default = 1
}

variable "asg_desired_capacity" {
  default = 1
}

variable "asg_wait_for_capacity_timeout" {
  default = 0
}

variable "private_instances" {
  description = "If set to true, the instances will use private subnets, otherwise public subnets"
  default     = true
}


# Health check fot the load balancer tarjet group
variable "health_path" {
  type = string
}

variable "health_matcher" {
  type = string
}

variable "health_protocol" {
  type    = string
  default = "HTTP"
}


variable "healthy_threshold" {
  type    = number
  default = 2
}

variable "unhealthy_threshold" {
  type    = number
  default = 3
}

variable "health_timeout" {
  type    = number
  default = 10
}

variable "health_interval" {
  type    = number
  default = 15
}

variable "health_check_grace_period" {
  type    = number
  default = 300
}

variable "optional_subdomain" {
  description = "Used in route53 record -> service.(optional_subdomain.)hosted_zone_name - Include the period after the subodmain because it is optional"
  default     = ""
}

variable "hosted_zone_id" {
  description = "Id of hosted zone to put DNS entry"
}
