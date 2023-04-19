
variable "env_name" {
  description = "Name of the environment, used for tagging and naming resources"
}

variable "vpc_id" {
  description = "Identifier of the VPC where TeamCenter is deployed"
}

variable "teamcenter_s3_bucket_name" {
  description = "teamcenter bucket"
}
variable "artifacts_bucket_name" {
  description = "S3 bucket to store artifacts"
}

variable "private_hosted_zone_arn" {
  description = "Internal DNS ARN"
}


variable "trail_name" {
  description = "cloud trail name"
}
