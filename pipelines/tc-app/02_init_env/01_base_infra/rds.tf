
# Subnet group with all the RDS subnets
resource "aws_db_subnet_group" "data" {
  name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-db" : "tc-${var.env_name}-db"
  description = "Database subnet group"
  subnet_ids  = [aws_subnet.env_subnet_1.id, aws_subnet.env_subnet_2.id]
}


# Security group for RDS
resource "aws_security_group" "rds" {
  name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-rds-sg" : "tc-${var.env_name}-rds-sg"
  description = "Security group for RDS"
  vpc_id      = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id

  ingress {
    description = "HTTP 1521 for Oracle RDS"
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-rds-sg" : "tc-${var.env_name}-rds-sg"
  }
}

# RDS Oracle DB instance
resource "aws_db_instance" "base_rds" {
  db_name                     = "TC"
  allocated_storage           = 50
  max_allocated_storage       = 250
  storage_type                = "gp3"
  storage_encrypted           = true
  kms_key_id                  = jsondecode(data.aws_s3_object.core_outputs.body).kms_key_arn
  engine                      = "oracle-se2"
  identifier                  = "${local.name_prefix}-db"
  engine_version              = "19.0.0.0.ru-2022-10.rur-2022-10.r1"
  auto_minor_version_upgrade  = true
  instance_class              = var.machines.db.instance_type
  username                    = var.db_user
  password                    = random_password.db_pass.result
  db_subnet_group_name        = aws_db_subnet_group.data.id
  skip_final_snapshot         = true
  copy_tags_to_snapshot       = true
  multi_az                    = false 
  publicly_accessible         = false
  vpc_security_group_ids      = [aws_security_group.rds.id]
  apply_immediately           = false
  backup_retention_period     = 30
  allow_major_version_upgrade = true
  license_model               = "license-included"
  availability_zone           = jsondecode(data.aws_s3_object.core_outputs.body).availability_zone_names[0]

  lifecycle {
    ignore_changes = [
      engine_version, # AWS auto updates the version during mainetance windows
      multi_az,
    ]
  }
}

