
resource "aws_backup_vault" "backup-vault" {
  count = var.backup_config.enabled ? 1 : 0
  name = "${local.prefix}-deployment-center"
  tags = {
    Application = "Teamcenter"
  }
  force_destroy = true
}

resource "aws_backup_plan" "backup-plan" {
  count = var.backup_config.enabled ? 1 : 0
  name = "${local.prefix}-deployment-center"
  rule {
    rule_name         = "${local.prefix}-deployment-center-${var.backup_config.retention_days}-day-retention"
    target_vault_name = aws_backup_vault.backup-vault[0].name
    schedule          = "${var.backup_config.cron_schedule}"
    start_window      = 60
    completion_window = 300

    lifecycle {
      delete_after = var.backup_config.retention_days
    }

    recovery_point_tags = {
      Application = "Teamcenter"
    }
  }

  tags = {
    Application = "Teamcenter"
  }
}

resource "aws_backup_selection" "server-backup-selection" {
  count = var.backup_config.enabled ? 1 : 0
  iam_role_arn = aws_iam_role.backup-service-role[0].arn
  name         = "${local.prefix}-deployment-center-selection"
  plan_id      = aws_backup_plan.backup-plan[0].id

 resources = [
    aws_efs_file_system.deployment_center.arn
  ]
  depends_on = [
    aws_backup_plan.backup-plan
  ]
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "pass-role-policy-doc" {
  statement {
    sid       = "PassRole"
    actions   = ["iam:PassRole"]
    effect    = "Allow"
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"]
  }
}

resource "aws_iam_role" "backup-service-role" {
  count = var.backup_config.enabled ? 1 : 0
  name               = "${local.prefix}-deployment-center-backups-role"
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
    Role    = "${local.prefix}-deployment-center-backups-role"
  }
}

resource "aws_iam_role_policy" "backup-service-pass-role-policy" {
  count = var.backup_config.enabled ? 1 : 0
  policy = data.aws_iam_policy_document.pass-role-policy-doc.json
  role   = aws_iam_role.backup-service-role[0].name
}

resource "aws_iam_role_policy_attachment" "backup-service-aws-backup-role-policy" {
  count = var.backup_config.enabled ? 1 : 0
  role       = aws_iam_role.backup-service-role[0].id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_iam_role_policy_attachment" "restore-service-aws-backup-role-policy" {
  count = var.backup_config.enabled ? 1 : 0
  role       = aws_iam_role.backup-service-role[0].id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}

