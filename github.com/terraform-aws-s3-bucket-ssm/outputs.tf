output "bucket_id" {
  description = "The name of the bucket."
  value       = aws_s3_bucket.bucket.id
}

output "bucket_region" {
  description = "The AWS region this bucket resides in."
  value       = aws_s3_bucket.bucket.region
}

output "bucket_arn" {
  description = "The ARN of the bucket."
  value       = aws_s3_bucket.bucket.arn
}

output "website_endpoint" {
  description = "The website endpoint of the bucket."
  value       = aws_s3_bucket.bucket.website_endpoint
}

output "bucket_domain_name" {
  description = "The bucket domain name."
  value       = aws_s3_bucket.bucket.bucket_domain_name
}

output "hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region."
  value       = aws_s3_bucket.bucket.hosted_zone_id
}