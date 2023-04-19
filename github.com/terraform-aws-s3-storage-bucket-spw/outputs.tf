output "bucket_id" {
  description = "The name of the bucket."
  value       = module.bucket.bucket_id
}

output "bucket_domain_name" {
  description = "The bucket domain name."
  value       = module.bucket.bucket_domain_name
}

output "bucket_arn" {
  description = "The ARN of the bucket."
  value       = module.bucket.bucket_arn
}

output "hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region."
  value       = module.bucket.hosted_zone_id
}

output "bucket_region" {
  description = "The AWS region this bucket resides in."
  value       = module.bucket.bucket_region
}

output "replica_id" {
  description = "The name of the replica bucket."
  value       = var.replica_flag != false ? element(module.replica.*.bucket_id, 0) : null
}

output "replica_arn" {
  description = "The ARN of the replica bucket."
  value       = var.replica_flag != false ? element(module.replica.*.bucket_arn, 0) : null
}