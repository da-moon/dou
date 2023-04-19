### Service Specific Configurations ##
variable "min_services_desired" {
  description = "The minimum number of services to run on the cluster"
  default     = 1
}

variable "max_services_desired" {
  description = "The maximum number of services to run on the cluster"
  default     = 20
}

variable "min_healthy_percent" {
  description = "The minimum healthy % of services currently desired to keep alive during deployments. Setting below 100 enables rolling deploys for fully saturated tasks with the distinctInstance placement constraint"
  default     = 100
}

variable "scaling_cpu_threshold" {
  description = "CPU threshold used in CW alarm that is referenced by app autoscaling targets for the api."
  default     = 99
}

variable "drain_duration" {
  description = "The duration a container will run after being dereigstered from the loadbalancer before being eligible to be terminated. A lower value will speed up rolling in-place deployments."
  default     = 30
}

variable "idle_timeout" {
  description = "Idle timeout to set on ALB http://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancers.html#connection-idle-timeout"
  default     = 30
}

## these variables are filled in during the CircleCi build CI ##

variable "container_image" {
  description = "Full path (namespace / image) for api container ECR image"
  default     = ""
}

variable "container_version" {
  description = "The version of the container image to use"
  default     = ""
}

variable "aws_region" {
  description = "Region to provision resources into"
}

variable "project" {
  description = "Bitbucket Project Name"
}

variable "url_scheme" {
  default = "http"
}

variable "endpoint" {
  default = "/"
}

variable "run_env" {

}

variable "landing_zone" {}
