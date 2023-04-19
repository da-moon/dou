output "user_name" {
  description = "The user's name."
  value       = aws_iam_user.user.name
}

output "arn" {
  description = "The ARN assigned by AWS for this user"
  value       = aws_iam_user.user.arn
}

output "encrypted_secret" {
  description = "Encrypted secret, base64 encoded"
  value       = aws_iam_access_key.key.encrypted_secret
}

output "access_key" {
  description = "Access key ID"
  value       = aws_iam_access_key.key.id
}

output "secret" {
  description = "Secret access key."
  value       = aws_iam_access_key.key.id
}
