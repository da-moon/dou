resource "aws_ses_email_identity" "email_identity_aws" {
  email = var.mail_identity
}