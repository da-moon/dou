resource "aws_iam_group" "group" {
  name = var.name
  path = var.path
}

resource "aws_iam_group_membership" "members" {
  name  = "${var.name}-members"
  users = var.users
  group = aws_iam_group.group.name
}