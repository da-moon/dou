###############
#  S3 Bucket  #
###############

resource "aws_s3_bucket" "bucket" {
  region = var.region
  bucket = "saj-${var.name_prefix}-${var.name}"
  acl    = var.acl
  policy = data.template_file.policy.rendered
  versioning {
    enabled = var.versioning
  }

  tags = {
    name = var.name
  }
}

server_side_encryption_configuration {
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "template_file" "policy" {
  template = file("${path.module}/policy.json.tpl")
  vars = {
    bucket_id = "saj-${var.name_prefix}-${var.name}"
  }
}
