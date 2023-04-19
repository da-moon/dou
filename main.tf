module "rds_base" {
  source = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/rds/base_rds_instance?ref=1.0.32"
  name = "${var.name}"
  instance_type = "${var.instance_type}"
  engine_type = "${var.engine_type}"
  route53_zone_id = "${var.route53_zone_id}"
  master_user = "${var.master_user}"
  master_password = "${var.master_password}"
  db_parameter_group = "${var.db_parameter_group}"
  run_env = "${var.run_env}"
  db_security_groups = "${var.db_security_groups}"
  db_subnet_ids = "${var.db_subnet_ids}"
  vpc_id = "${var.vpc_id}"
  storage_encryption = "${var.storage_encryption}"
  snapshot_id = "${var.snapshot_id}"
  enhanced_monitoring = var.enhanced_monitoring
  db_size = var.db_size
}


#*******************************************************************************
# Single region replica
#*******************************************************************************
resource "aws_db_instance" "base_rds_replica" {
  identifier                = "${var.run_env}-${var.name}-replica"
  replicate_source_db       = "${var.run_env}-${var.name}"
  instance_class            = "${var.instance_type}"
  skip_final_snapshot = true
  final_snapshot_identifier = null
  storage_encrypted         = "${var.storage_encryption}"

  depends_on = [module.rds_base.identifier]
}

resource "aws_route53_record" "cname_record_replica" {
  zone_id = var.route53_zone_id
  name    = "${var.name}.replica"
  type    = "CNAME"
  ttl     = 300
  records = [aws_db_instance.base_rds_replica.address]
}
#*******************************************************************************
