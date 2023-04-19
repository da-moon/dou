# Create s3 bucket
resource "aws_s3_bucket" "plm_hub_bucket" {
  bucket        = var.s3_bucket
  #acl           = "private"
  #force_destroy = true

  tags = {
    Name = var.s3_bucket
  }
}
