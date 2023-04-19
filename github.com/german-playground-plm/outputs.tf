
output "bastion_ip" {
  description = "The public ip of bastion host for ssh access"
  value       = aws_instance.bastion_host.public_ip
}

