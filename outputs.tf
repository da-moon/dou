output "s3_notification_id" {
  description = "The ID of the bucket notification."
  value       = aws_s3_bucket_notification.bucket_notification.id
}