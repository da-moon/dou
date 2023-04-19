resource "aws_s3_bucket" "plm_bucket" {
  bucket = var.project_name
  #acl           = "private"
  force_destroy = true

  tags = {
    Name = var.project_name
  }
}