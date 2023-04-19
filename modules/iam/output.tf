output "smtp_user_id" {
  value = "${aws_iam_access_key.smtp_user.id}"
}
output "smtp_password" {
  value = "${aws_iam_access_key.smtp_user.ses_smtp_password_v4}"
}
