
variable "installation_prefix" {
  description = "A prefix to add to all resources created. Used to support multiple different installations of engineering in cloud."
  type        = string
}

variable "region" {
  description = "The region where all the resources will de deployed"
  type        = string
}

variable "artifacts_bucket_name" {
  description = "S3 bucket name for CI/CD automation, where pipeline artifacts are stored"
  type        = string
}

variable "vpc_id" {
  description = "Already existing VPC"
  type        = string
  default     = ""
}

variable "cidr_public_subnets" {
  description = "Public CIDR range for VPC"
  type        = list(string)
  default     = null
}

variable "cidr_private_build_subnets" {
  description = "Private CIDR range for Build sever in a VPC"
  type        = list(string)
  default     = null

}

## variable for https
variable "certificate_arn" {
  description = "ARN of the default SSL server certificate"
  type        = string
  default     = ""

}

variable "ssl_policy" {
  description = "Name of the SSL Policy for the listener"
  type        = string
  default     = ""
}

variable "is_https" {
  description = "enable https"
  type        = bool
}

variable "ecr" {
  description = "Name of the ecr repository"
  type        = list(string)
  default = ["siemens/teamcenter/afx-darsi",
    "siemens/teamcenter/afx-gateway",
    "siemens/teamcenter/eureka_server",
    "siemens/teamcenter/file-repo",
    "siemens/teamcenter/microserviceparameterstore",
    "siemens/teamcenter/service_dispatcher",
  "siemens/teamcenter/tcgql"]
}

variable "zone" {
  description = "Name of the internal domain"
  type        = string
}

variable "self_signed_cert" {
  description = "Map for ssl self signed certificate"
  type = object({
    country = string 
    state = string 
    locality = string 
    organization = string 
    unit = string 
  })
  default = {
    country = "US" 
    state = "California" 
    locality = "San Francisco" 
    organization = "" 
    unit = "Internal" 
  }
}

variable "force_rebake" {
  description = "If true, the EBS software repository will be rebuilt even if there haven't been any changes."
  type        = bool
  default     = false
}

variable "software_repo_s3_uri" {
  description = "URI in s3:// format to where the software for teamcenter and deployment center is stored."
  type        = string
}

variable "deployment_center" {
  description = "Different settings for Deployment Center"
  type        = object({
    folder_to_install = string
    instance_type     = string
    backup_config     = object({
      enabled         = bool
      cron_schedule  = string
      retention_days = number
    })
  })
}
