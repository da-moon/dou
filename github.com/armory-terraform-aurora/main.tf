locals {
  name = "armory-aurora"
  tags = {
    Owner     = "armory.ps@digitalonus.com"
    Terraform = true
  }
}

resource "random_password" "master" {
  length = 10
}

data "aws_db_subnet_group" "selected" {
  name = "armory-spinnaker-dev-vpc"
}

data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [data.aws_db_subnet_group.selected.vpc_id]
  }

  filter {
    name = "tag:Name"
    values = [
      "armory-spinnaker-dev-vpc-private-${var.region}a",
      "armory-spinnaker-dev-vpc-private-${var.region}b",
      "armory-spinnaker-dev-vpc-private-${var.region}c"
    ]
  }
}

data "aws_subnet" "selected" {
  for_each = toset(data.aws_subnets.selected.ids)
  id       = each.value
}

module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "6.1.4"

  name           = local.name
  engine         = "aurora-mysql"
  engine_version = "5.7"
  instances = {
    1 = {
      instance_class      = "db.r3.large"
      publicly_accessible = true
    }
    # 2 = {
    #   identifier     = "mysql-static-1"
    #   instance_class = "db.r3.large"
    # }
    # 3 = {
    #   identifier     = "mysql-excluded-1"
    #   instance_class = "db.r3.large"
    #   promotion_tier = 15
    # }
  }

  vpc_id                 = data.aws_db_subnet_group.selected.vpc_id
  db_subnet_group_name   = data.aws_db_subnet_group.selected.name
  create_db_subnet_group = false
  create_security_group  = true
  allowed_cidr_blocks    = concat([for s in data.aws_subnet.selected : s.cidr_block], ["0.0.0.0/0"])

  iam_database_authentication_enabled = true
  master_password                     = random_password.master.result
  create_random_password              = false

  apply_immediately           = true
  skip_final_snapshot         = true
  create_monitoring_role      = false
  allow_major_version_upgrade = true

  db_parameter_group_name         = aws_db_parameter_group.aurora.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora.id
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  tags = local.tags
}

resource "aws_db_parameter_group" "aurora" {
  name        = "${local.name}-db-57-parameter-group"
  family      = "aurora-mysql5.7"
  description = "${local.name}-db-57-parameter-group"
  tags        = local.tags

  parameter {
    name  = "max_allowed_packet"
    value = 25165824
  }
}

resource "aws_rds_cluster_parameter_group" "aurora" {
  name        = "${local.name}-57-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "${local.name}-57-cluster-parameter-group"
  tags        = local.tags

  parameter {
    name         = "character-set-client-handshake"
    value        = false
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "max_allowed_packet"
    value = 25165824
  }
}