resource "aws_iam_user" "smtp_user" {
  name = var.smtp_user
}

resource "aws_iam_user_policy_attachment" "PowerUserAccess-attach" {
  user      = aws_iam_user.smtp_user.name
  policy_arn = var.policy_arn
}

resource "aws_iam_access_key" "smtp_user" {
  user = aws_iam_user.smtp_user.name
}