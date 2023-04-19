
variable "instance_subnets" {
  description = "List of subnets where the Deployment Center instance will be deployed"
  type        = list(string)
}

variable "lb_subnets" {
  description = "List of subnets where the Deployment Center load balancer will be deployed"
  type        = list(string)
}

variable "artifacts_bucket_name" {
  description = "S3 bucket name for CI/CD automation, where pipeline artifacts are stored"
  type        = string
}

variable "force_rebake" {
  description = "If true, packer will run even if there are any changes."
  type        = bool
}

variable "delete_data" {
  description = "If true, all Deployment Center data will be deleted."
  type        = bool
  default     = false
}

variable "dc_user_secret_name" {
  description = "Name of the Secrets Manager secret that has the Deployment Center username"
  type        = string
}

variable "dc_pass_secret_name" {
  description = "Name of the Secrets Manager secret that has the Deployment Center password"
  type        = string
}

variable "dc_folder_to_install" {
  description = "Name of the folder within the software repository containing the Deployment Center software to be installed"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type to use for Deployment Center"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 private hosted zone associated to Deployment Center VPC"
  type        = string
}

variable "installation_prefix" {
  description = "Prefix to use for naming resources"
  type        = string
}

variable "ssh_key_name" {
  description = "Name of the SSH key to use to install in the server"
  type        = string
}

variable "backup_config" {
  description = "Rules for automated backups"
  type        = object({
    enabled        = bool
    retention_days = number
    cron_schedule  = string
  })
}

variable "ssl_policy" {
  default = "ELBSecurityPolicy-2016-08"
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate to use for the load balancer"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key to use for encryption of EBS and EFS"
  type        = string
}

