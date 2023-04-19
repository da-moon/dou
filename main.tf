provider "aws" {
  alias  = "dr"
}

module "rds_replica" {
  source = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/rds/base_rds_instance_with_replica?ref=1.0.32"
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
# Cross-region Replica for Disaster Recovery
#*******************************************************************************
resource aws_kms_key "rds_kms_key" {
  provider = aws.dr
  description = "RDS KMS Key"
}

resource "aws_db_subnet_group" "cross_region_subnet_group" {
  provider = aws.dr
  name        = "${var.run_env}-db-${var.name}-cross-region-subnet"
  description = "Database subnet group for cross-region replica"
  subnet_ids  = split(",", var.cross_region_replica_subnet_ids)
}

resource "aws_db_instance" "rds_cross_region_replica" {
  provider = aws.dr
  identifier   = "${var.run_env}-${var.name}-cross-region-replica"
  kms_key_id = "${aws_kms_key.rds_kms_key[0].arn}"
  replicate_source_db = "${module.rds_replica.source_instance_arn}"
  instance_class = "${var.instance_type}"
  final_snapshot_identifier = "${var.run_env}-${var.name}-cross-region-replica-final-snapshot"
  storage_encrypted = "${var.storage_encryption}"
  db_subnet_group_name = "${var.run_env}-db-${var.name}-cross-region-subnet"
}

resource "aws_route53_record" "cname_record_cross_replica" {
  provider = aws.dr
  zone_id = "${var.route53_zone_id}"
  name = "${var.name}.cross-region-${var.run_env}"
  type = "CNAME"
  ttl = "300"
  records = [aws_db_instance.rds_cross_region_replica[0].address]

}
#*******************************************************************************
