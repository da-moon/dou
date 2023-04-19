output "s3_bucket_id" {
  description = "The key of S3 object"
  value       = try(aws_s3_bucket.this.id, "")
}