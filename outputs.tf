output "group_id" {
  description = "The group's ID."
  value       = aws_iam_group.group.id
}

output "group_name" {
  description = "The group's name."
  value       = aws_iam_group.group.name
}

output "arn" {
  description = "The ARN assigned by AWS for this group."
  value       = aws_iam_group.group.arn
}

output "users" {
  description = "List of IAM User names"
  value       = aws_iam_group_membership.members.users
}