## AWSBackup of RDS
module "rds_efs_backup" {
  count         = var.env_backup_config.enabled ? 1 : 0
  source        = "../../../../components/terraform/awsbackup"
  env_name      = var.env_name
  prefix_name   = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}" : "tc-${var.env_name}"
  fs_service    = "rds"
  arn           = aws_db_instance.base_rds.arn
  backup_config = var.env_backup_config
}


## AWSBackup of EFS
module "tc_efs_backup" {
  count         = var.env_backup_config.enabled ? 1 : 0
  source        = "../../../../components/terraform/awsbackup"
  env_name      = var.env_name
  prefix_name   = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}" : "tc-${var.env_name}"
  fs_service    = "tc_efs"
  arn           = module.tc_efs.efs_arn
  backup_config = var.env_backup_config
}
