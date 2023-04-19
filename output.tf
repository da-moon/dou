output "instance_id" {
  value = aws_instance.bind_instance.id
}

output "private_ip" {
  value = aws_instance.bind_instance.private_ip
}

