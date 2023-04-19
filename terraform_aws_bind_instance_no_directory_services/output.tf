output "instance_id" {
  value = aws_instance.bind_instance[0].id
}

output "private_ip" {
  value = aws_instance.bind_instance[0].private_ip
}

