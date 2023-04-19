resource "aws_iam_user" "user" {
  name = var.user_name
  path = var.path

  force_destroy        = var.user_destroy
  permissions_boundary = var.permissions_boundary

  tags = var.tags
}

resource "aws_iam_access_key" "key" {
  user    = aws_iam_user.user.name
  pgp_key = var.pgp_key
  status  = var.key_status
}