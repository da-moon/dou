
output "ssh_key_name" {
  value = aws_key_pair.generated_key.key_name
}

output "kms_key_id" {
  value = aws_kms_key.main.id
}

output "kms_key_arn" {
  value = aws_kms_key.main.arn
}

output "ssh_private_key_arn" {
  value = aws_secretsmanager_secret.pem_file.arn
}

output "ssh_private_key_name" {
  value = aws_secretsmanager_secret.pem_file.name
}

