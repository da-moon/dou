##################################################
#  S3 Policy  with denying update without kms key#
##################################################
resource "aws_s3_bucket" "s3_bucket" {
  region = var.region
  bucket = "cv-${var.name_prefix}-${var.name}"
  acl    = var.acl
  versioning {
    enabled = var.versioning
  }
  policy = data.template_file.policy.rendered
  tags = {
    name = var.name
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
    s3_bucket = "cv-${var.name_prefix}-${var.name}"
  }
}
