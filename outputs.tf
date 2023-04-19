output "id" {
  description = "ID of the security group."
  value       = aws_security_group.sg.id
}

output "name" {
  description = "Security Group Name"
  value       = aws_security_group.sg.name
}

output "owner_id" {
  description = "Owner ID."
  value       = aws_security_group.sg.owner_id
}

output "arn" {
  description = "ARN of the security group."
  value       = aws_security_group.sg.arn
}