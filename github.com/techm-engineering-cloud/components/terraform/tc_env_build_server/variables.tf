
variable "installation_prefix" {
  description = "Prefix to use for all installation components"
  type        = string
}

variable "env_name" {
  description = "Name of the teamcenter environment"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets where the build server will be deployed"
  type        = list(string)
}

variable "build_subnet_id" {
  description = "Subnet where the build server AMI will be created"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key to use for encryption"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the build server"
  type        = string
}

variable "artifacts_bucket_name" {
  description = "Name of the S3 bucket where build artifacts are stored"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 private hosted zone associated to build server VPC"
  type        = string
}

variable "tc_efs_id" {
  description = "Identifier of the EFS file system shared across all servers of the environment"
  type        = string
}

variable "ssh_key_name" {
  description = "SSH key to use for logging in to the server"
  type        = string
}

variable "force_rebake" {
  description = "If true, the AMI for build server will be regenereated even if there are no changess"
  type        = bool
}

variable "sm_db_name" {
  description = "Name of the Server Manager tablespace"
  type        = string
  default     = "TCClusterDB"
}

variable "keystore_secret_name" {
  description = "Secret name in Secrets Manager of microservice keystore password"
  type        = string
}
