output "instance_id" {
  value = aws_instance.buildserver.id
}

output "instance_public_id" {
  value = aws_instance.buildserver.public_ip
}
