output "bucket_id" {
  value = aws_s3_bucket.bucket.id
}

output "website_endpoint" {
  value = aws_s3_bucket.bucket.website_endpoint
}

output "bucket_domain_name" {
  value = aws_s3_bucket.bucket.bucket_domain_name
}

output "hosted_zone_id" {
  value = aws_s3_bucket.bucket.hosted_zone_id
}

# output "website_domain" {
#   value = "${aws_s3_bucket.bucket.website_domain}"
# }
