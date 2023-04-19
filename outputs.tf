# SFTP Outputs
output "sftp_endpoint" {
  value = aws_transfer_server.sftp_server.endpoint
}

output "sftp_server_id" {
  value = aws_transfer_server.sftp_server.id
}
