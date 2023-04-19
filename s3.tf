resource "aws_s3_bucket" "spinnaker_bucket" {
  bucket = "dou-armory-spinnaker"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    name        = "dou-armory-spinnaker"
    environment = var.environment
  }
}

resource "aws_s3_bucket" "spin_secrets" {
  bucket = "dou-armory-spinnaker-secrets"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    project     = "armory"
    environment = var.environment
  }
}
