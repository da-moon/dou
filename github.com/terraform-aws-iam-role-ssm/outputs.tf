output "role_id" {
  description = "ID of the role."
  value       = aws_iam_role.role.id
}

output "role_name" {
  description = "Name of the role."
  value       = aws_iam_role.role.name
}

output "arn" {
  description = "Amazon Resource Name (ARN) specifying the role."
  value       = aws_iam_role.role.arn
}

output "create_date" {
  description = "Creation date of the IAM role."
  value       = aws_iam_role.role.create_date
}