data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "pass-role-policy-doc" {
  statement {
    sid       = "ExamplePassRole"
    actions   = ["iam:PassRole"]
    effect    = "Allow"
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"]
  }
}

resource "aws_iam_role" "backup-service-role" {
  name               = "${var.prefix_name}-${var.fs_service}-backups-role"
  description        = "Allows the AWS Backup Service to take scheduled backups"
  assume_role_policy = <<POLICY
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
  tags = {
    Application = "Teamcenter"
    Role    = "${var.prefix_name}-${var.fs_service}-backups-role"
  }
}

resource "aws_iam_role_policy" "backup-service-pass-role-policy" {
  policy = data.aws_iam_policy_document.pass-role-policy-doc.json
  role   = aws_iam_role.backup-service-role.name
}

resource "aws_iam_role_policy_attachment" "backup-service-aws-backup-role-policy" {
  role       = aws_iam_role.backup-service-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_iam_role_policy_attachment" "restore-service-aws-backup-role-policy" {
  role       = aws_iam_role.backup-service-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}
