variable "installation_prefix" {
  description = "A prefix to add to all resources created. Used to support multiple different installations of engineering in cloud."
  type        = string
  default     = ""
}

variable "bootstrap_region" {
  description = "AWS region where bootstrap components will be installed, like any CI/CD and state files."
  type        = string
}

variable "bootstrap_bucket_name" {
  description = "AWS S3 bucket name where terraform state files will be stored."
  type        = string
}

#---------------------------------- VCS specific variables ----------------------------------

variable "vcs_reponame" {
  description = "Name of the git repository that will host all the infrastructure as code"
  type        = string
  default     = "techm-engineering-cloud"
}

variable "vcs_provider" {
  description = "Indicates what VCS provider should be used to store the infrastructure as code. Currently only AWS COdeCOmmit is supported."
  type        = string
  default     = "codecommit"
}

#---------------------------------- PLM specific variables ----------------------------------

variable "teamcenter_enabled" {
  description = "Wether or not TeamCenter will be installed"
  type        = bool
}

variable "teamcenter_bs_base_ami" {
  description = "Base AMI for the build server, which includes Deployment Center and Active Workspace Builder"
  type        = string
  default     = ""
}

variable "teamcenter_s3_bucket_name" {
  description = "AWS S3 bucket name where teamcenter softwares will be stored."
  type        = string
}
