output "fsx_openzfs_id" {
  description = "The key of FXS OpenZFS"
  value       = aws_fsx_openzfs_file_system.fs.id
}

output "fsx_openzfs_dns_name" {
  description = "DNS name for the file system, e.g., fs-12345678.fsx.us-west-2.amazonaws.com"
  value       = aws_fsx_openzfs_file_system.fs.dns_name
}