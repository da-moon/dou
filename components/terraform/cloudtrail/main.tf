resource "aws_cloudtrail" "my-trail" {
  name                          = var.trail_name
  s3_bucket_name                = aws_s3_bucket.trail-bucket.id
  is_multi_region_trail         = var.is_multi_region_trail
  include_global_service_events = var.include_global_service_events
  kms_key_id                    = var.kms_key_id
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_roles.arn
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  enable_log_file_validation    = var.enable_log_file_validation
  enable_logging                = var.enable_logging
  depends_on                    = [aws_s3_bucket_policy.bucket-policy]
}

###Create S3 bucket
resource "aws_s3_bucket" "trail-bucket" {
  bucket_prefix = var.bucket_prefix
  acl           = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_key_id
        sse_algorithm     = "aws:kms"
      }
    }
  }
  versioning {
    enabled    = false
    mfa_delete = false
  }
}

##Make cloudtrail bucket and objects as private
resource "aws_s3_bucket_public_access_block" "trail-bucket-access" {
  bucket                  = aws_s3_bucket.trail-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# This CloudWatch Group is used for storing CloudTrail logs.
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = var.cloudwatch_log_group_name
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_id ###aws_kms_key.cloudtrail.arn
}