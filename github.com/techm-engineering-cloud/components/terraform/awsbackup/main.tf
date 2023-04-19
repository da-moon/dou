resource "aws_backup_vault" "backup-vault" {
  name = "${var.prefix_name}-${var.fs_service}-backup-vault"
  tags = {
    Application = "Teamcenter"
    Role    = "${var.prefix_name}-${var.fs_service}"
    Env = "${var.env_name}"
  }
  force_destroy = true
}

resource "aws_backup_plan" "backup-plan" {
  name = "${var.prefix_name}-${var.fs_service}-backup-plan"
  rule {
    rule_name         = "${var.prefix_name}-${var.fs_service}-${var.backup_config.retention_days}-day-retention"
    target_vault_name = aws_backup_vault.backup-vault.name
    schedule          = "${var.backup_config.cron_schedule}"
    start_window      = 60
    completion_window = 300

    lifecycle {
      delete_after = var.backup_config.retention_days
    }

    recovery_point_tags = {
      Application = "Teamcenter"
      Role    = "${var.prefix_name}-${var.fs_service}"
      Env = "${var.env_name}"
      Creator = "aws-backups"
    }
  }

  tags = {
    Application = "Teamcenter"
    Role    = "${var.prefix_name}-${var.fs_service}"
    Env = "${var.env_name}"
  }
}

resource "aws_backup_selection" "server-backup-selection" {
  iam_role_arn = aws_iam_role.backup-service-role.arn
  name         = "${var.prefix_name}-${var.fs_service}-selection"
  plan_id      = aws_backup_plan.backup-plan.id

 resources = [
    var.arn
  ]
  depends_on = [
    aws_backup_plan.backup-plan
  ]
}
