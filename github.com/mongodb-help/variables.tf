
//Mongo
variable "project_id" {
  default = ""
}
variable "org_id" {
  default = ""
}
variable "private_key" {
  default = ""
}
variable "public_key" {
  default = ""
}
variable "cluster_name" {
  default = ""
}
variable "description" {
  default = "description test"
}


variable "subscription_id" {
  default = ""
}
variable "client_id" {
  default = ""
}
variable "client_secret" {
  default = ""
}
variable "tenant_id" {
  default = ""
}
variable "resource_group_name" {
  default = ""
}


variable "aws_access_key" {
  description = "The access key for AWS Account"
  default = ""
}
variable "aws_secret_key" {
  description = "The secret key for AWS Account"
  default = ""
}
variable "aws_customer_master_key" {
  description = "The customer master secret key for AWS Account"
  default = ""
}
variable "atlas_region" {
  default     = ""
  description = "Atlas Region"
}
variable "aws_region" {
  default     = ""
  description = "AWS Region"
}
variable "aws_iam_role_arn" {
  description = "AWS IAM ROLE ARN"
  default     = ""
}
variable "gcp_service_account_key" {
  default     = ""
  description = "AWS Region"
}
variable "gcp_key_version_resource_id" {
  description = "AWS IAM ROLE ARN"
  default     = ""
}