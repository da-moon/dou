resource "aws_s3_bucket" "caas_bucket" {
  bucket        = "${var.project_name}-bucket-${var.run_env}"
  acl           = "private"
  force_destroy = true

  tags = {
    Name        = "${var.project_name}-bucket-${var.run_env}"
    Environment = var.run_env
  }
}