#Value of the route of your aws IAM credentials
variable "aws_credentials_location" {
  type        = string
  default     = "/route/to/.aws/credentials"
  description = "AWS Credentials location"
}

#Name of the profile name that is going to use for the IAM crdentials
variable "aws_profile_name" {
  type        = string
  default     = "default"
  description = "AWS profile name"
}

#Select the AWS region that you are going to use
variable "region" {
  type        = string
  default     = "aws_region"
  description = "AWS region"
}

#You must have access to the identity mail
variable "mail_identity" {
  type        = string
  default     = "email@example.com"
  description = "mail Identity for the Amazon SES"
}

#The user who is going to enter to the S3 bucket
variable "smtp_user" {
  type        = string
  default     = "smtp_user"
  description = "Name of the new smtp user"
}

#Policy with the required permissions to access to the S3 Bucket
variable "policy_arn" {
  type        = string
  default     = "arn:aws:iam::aws:policy/examplePolicy"
  description = "Policy's ARN that is attached to the user"
}

#Change the server smtp endpoint name.
variable "smtp_endpoint" {
  type        = string
  default     = "host_example.amazonaws.com"
  description = "AWS SMTP endpoint"
}

#The name of the Spinnaker secrets file
variable "ss_file_name" {
  type        = string
  default     = "spinnaker-secrets.yml"
  description = "Name of the file with the secrets"
}

#Change this value for your own location file
variable "ss_file_location" {
  type        = string
  default     = "/Route/to/spinnaker/secrets/file/spinnaker-secrets.yml"
  description = "file location of spinnaker-secrets.yml on your local machine"
}

#Change this value, remember that the name must be unique
variable "bucket_name" {
  type        = string
  default     = "bucket-example"
  description = "S3 bucket name"
}
