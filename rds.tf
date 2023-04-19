resource "aws_db_instance" "base_rds" {
  name                 = var.db_name
  #db_name             = var.db_name
  allocated_storage    = var.db_size
  max_allocated_storage= var.max_db_size
  storage_type         = var.storage_type
  engine               = var.engine_type
  identifier           = "${var.project_name}-db"
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.master_user
  password             = var.master_password
  db_subnet_group_name = aws_db_subnet_group.data.id
  skip_final_snapshot    = true
  copy_tags_to_snapshot  = true
  multi_az               = var.db_multi_az
  publicly_accessible    = false 
  vpc_security_group_ids = [aws_security_group.caas_dev.id]
  apply_immediately           = false # was true
  backup_retention_period     = var.backup_retention_period
  allow_major_version_upgrade = true
  # storage_encrypted           = var.storage_encryption
  # parameter_group_name        = var.db_parameter_group
  # final_snapshot_identifier = "${var.run_env}-${var.name}-final-snapshot"
  # monitoring_role_arn         = var.enhanced_monitoring
  # monitoring_interval             = var.monitor_interval
  # enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  # snapshot_identifier   = "${var.snapshot_id}"
}

resource "aws_db_subnet_group" "data" {
  name        = "${var.project_name}-${var.run_env}-db-${var.name}"
  description = "Database subnet group"
  subnet_ids  = [aws_subnet.caas_private[0].id, aws_subnet.caas_private[1].id]
}

resource "aws_route53_record" "cname_record" {
  zone_id = data.aws_route53_zone.douterraform.id
  name    = "${var.project_name}.${var.name}.db"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.base_rds.address]
}

resource "aws_security_group" "db_access" {
  name        = "${var.run_env}-${var.name}-${var.engine_type}-access"
  description = "Apply this group to VPC resources that need to access the ${var.name} ${var.engine_type} DB"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${var.run_env}-${var.name}-${var.engine_type}-access"
  }
}

