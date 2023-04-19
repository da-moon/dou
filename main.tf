resource "aws_db_instance" "base_rds" {
  name                        = var.engine_type == "sqlserver-ex" ? "" : var.initial_database
  allocated_storage           = var.db_size
  storage_type                = "gp2"
  engine                      = var.engine_type
  identifier                  = "${var.run_env}-${var.name}"
  engine_version              = var.engine_version
  instance_class              = var.instance_type
  username                    = var.master_user
  password                    = var.master_password
  db_subnet_group_name        = aws_db_subnet_group.data.id
  parameter_group_name        = var.db_parameter_group
  final_snapshot_identifier   = "${var.run_env}-${var.name}-final-snapshot"
  copy_tags_to_snapshot       = true
  multi_az                    = var.db_multi_az
  publicly_accessible         = false
  vpc_security_group_ids      = split(",", var.db_security_groups)
  storage_encrypted           = var.storage_encryption
  apply_immediately           = true
  backup_retention_period     = var.backup_retention_period
  allow_major_version_upgrade = true
  monitoring_role_arn         = var.enhanced_monitoring
  monitoring_interval         = var.monitor_interval
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  #snapshot_identifier   = "${var.snapshot_id}"
  lifecycle {
    ignore_changes = [snapshot_identifier]
  }
}

resource "aws_db_subnet_group" "data" {
  name        = "${var.run_env}-db-${var.name}"
  description = "Database subnet group"
  subnet_ids  = split(",", var.db_subnet_ids)
}

resource "aws_route53_record" "cname_record" {
  zone_id = var.route53_zone_id
  name    = "${var.name}.db"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.base_rds.address]
}

resource "aws_security_group" "db_access" {
  name        = "${var.run_env}-${var.name}-${var.engine_type}-access"
  description = "Apply this group to VPC resources that need to access the ${var.name} ${var.engine_type} DB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.run_env}-${var.name}-${var.engine_type}-access"
  }
}