output "efs_id" {
  value = aws_efs_file_system.fs.id
}

output "efs_security_group_id" {
  value = aws_security_group.efs.id
}

output "efs_arn" {
  value = aws_efs_file_system.fs.arn
}