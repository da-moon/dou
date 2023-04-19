resource "aws_s3_bucket" "bucket" {
  bucket = var.name
  acl    = var.acl
  policy = var.policy

  versioning {
    enabled = var.versioning
  }

  dynamic "website" {
    for_each = local.website_configuration["index_document"] != null ? [1] : []
    content {
      index_document           = local.website_configuration.index_document
      error_document           = local.website_configuration.error_document
      redirect_all_requests_to = local.website_configuration.redirect_document
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.sse_algorithm
        kms_master_key_id = var.kms_master_key_id
      }
    }
  }

  dynamic "replication_configuration" {
    for_each = var.replication_configuration["iam_role_arn"] != null ? [1] : []
    content {
      role = var.replication_configuration.iam_role_arn
      rules {
        id     = var.replication_configuration.replica_id
        status = var.replication_configuration.status
        destination {
          bucket        = var.replication_configuration.replica_bucket_arn
          storage_class = var.replication_configuration.storage_class
        }
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      id      = lifecycle_rule.key
      prefix  = lifecycle_rule.value.lifecycle_rule_prefix
      enabled = lifecycle_rule.value.enabled

      dynamic "transition" {
        for_each = lifecycle_rule.value.transition
        content {
          days          = transition.value["days"]
          storage_class = transition.value["storage_class"]
        }
      }

      dynamic "expiration" {
        for_each = lifecycle_rule.value.expiration != null ? [1] : []
        content {
          days = lifecycle_rule.value.expiration
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = length(lifecycle_rule.value.noncurrent_version_transition) > 0 ? lifecycle_rule.value.noncurrent_version_transition : []
        content {
          days          = noncurrent_version_transition.value["days"]
          storage_class = noncurrent_version_transition.value["storage_class"]
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = lifecycle_rule.value.noncurrent_version_expiration != null ? [1] : []
        content {
          days = lifecycle_rule.value.noncurrent_version_expiration
        }
      }
    }
  }

  tags = var.tags
}