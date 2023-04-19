variable "installation_prefix" {
  description = "A prefix to add to all resources created. Used to support multiple different installations of engineering in cloud."
  type        = string
}

variable "artifacts_bucket_name" {
  description = "S3 bucket name for CI/CD automation, where pipeline artifacts are stored"
}

variable "machines" {
  description = "Object describing TeamCenter machine names, instance types and number of instances"
  type = object({
    ms_manager = object({
      instances     = number
      instance_type = string
    })
    ms_worker = object({
      instances     = number
      instance_type = string
    })
  })
  default = {
    ms_manager = {
      instance_type = "m5.large"
      instances     = 3
    }
    ms_worker = {
      instance_type = "m5.large"
      instances     = 2
    }
  }
}

variable "env_name" {
  description = "Name of the environment, used for tagging and naming resources"
}

variable "region" {
  description = "The region where all the resources will de deployed"
  type        = string
}

##Swarm Subnet CIDR range
variable "swarm_cidr_private_subnets" {
  description = "Swarm CIDR ranges"
  type        = list(string)
  default     = null
}
variable "ignore_tc_errors" {
  description = "If true the installation errors that can happen when team center is not installed on purpose will be ignored"
  type        = bool
  default     = true
}
variable "force_rebake" {
  description = "If true, the build server AMI will be recreated again. Used when the TeamCenter available software in the S3 bucket changes."
  type        = bool
  default     = false
}