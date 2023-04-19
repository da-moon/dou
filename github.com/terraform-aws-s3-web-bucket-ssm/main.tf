###############
#  S3 Bucket  #
###############

resource "aws_s3_bucket" "bucket" {
  region = var.region
  bucket = "cv-${var.name_prefix}-${var.name}"
  acl    = var.acl
  policy = data.template_file.policy.rendered
  versioning {
    enabled = var.versioning
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    name = "cv-${var.name_prefix}-${var.name}"
  }
}

data "template_file" "policy" {
  template = file("${path.module}/policy.json.tpl")
  vars = {
    bucket_id = "cv-${var.name_prefix}-${var.name}"
  }
}
