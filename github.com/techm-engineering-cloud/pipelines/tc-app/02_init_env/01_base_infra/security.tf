data "aws_caller_identity" "current" {}

data "aws_vpc" "main" {
  id = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id
}

## Solr indexing vm sec group code
resource "aws_security_group" "solr_indexing" {
  name        = var.installation_prefix != "" ? "${var.installation_prefix}-${var.env_name}-solr-indexing-sg" : "${var.env_name}-solr-indexing-sg"
  description = "Security group attached to solr indexing server instances"
  vpc_id      = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 8983
    to_port         = 8983
    protocol        = "tcp"
    security_groups = [aws_security_group.solr_indexing_lb.id]
  }

  ingress {
    description = "SSH from same vpc"
    from_port   = 22
    to_port     = 22
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
    Name = var.installation_prefix != "" ? "${var.installation_prefix}-${var.env_name}-solr-indexing-sg" : "${var.env_name}-solr-indexing-sg"
  }
}


##==================== Webserver security group ===============================

resource "aws_security_group" "webserver" {
  name        = var.installation_prefix != "" ? "${var.installation_prefix}-${var.env_name}-webserver-sg" : "${var.env_name}-webserver-sg"
  description = "Security group attached to webserver server instances"
  vpc_id      = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id

  ingress {
    description     = "Web traffic from ALB"
    from_port       = 8080 # This is hardcoded because jboss ignores the setting in the quick deploy file
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_lb.id]
  }

  ingress {
    description      = "AW gateway traffic from ALB"
    from_port        = nonsensitive(data.aws_ssm_parameter.aw_gateway_port.value)
    to_port          = nonsensitive(data.aws_ssm_parameter.aw_gateway_port.value)
    protocol         = "tcp"
    security_groups  = local.is_web_aw_same_dns ? [aws_security_group.webserver_lb.id] : [aws_security_group.webserver_lb.id, aws_security_group.awg[0].id]
  }

  ingress {
    description = "SSH from same vpc"
    from_port   = 22
    to_port     = 22
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
    Name = var.installation_prefix != "" ? "${var.installation_prefix}-${var.env_name}-webserver-sg" : "${var.env_name}-webserver-sg"
  }
}

##============Enterprise server======================================================
resource "aws_security_group" "enterprise" {
  name        = var.installation_prefix != "" ? "${var.installation_prefix}-${var.env_name}-enterprise-sg" : "${var.env_name}-enterprise-sg"
  description = "Security group attached to enterprise server instances"
  vpc_id      = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id


  ingress {
    description = "SSH from same vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  ingress {
    description = "FSC requests from same VPC"
    from_port   = 4544
    to_port     = 4544
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  ingress {
    description = "Corporate Server requests from same VPC"
    from_port   = 42074
    to_port     = 42074
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  ingress {
    description = "Enterprise requests from same VPC"
    from_port   = 8086
    to_port     = 8086
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  ingress {
    description = "Enterprise requests from same VPC"
    from_port   = 8087
    to_port     = 8087
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  ingress {
    description = "Enterprise requests from same VPC"
    from_port   = 8088
    to_port     = 8088
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
    Name = var.installation_prefix != "" ? "${var.installation_prefix}-${var.env_name}-enterprise-sg" : "${var.env_name}-enterprise-sg"
  }
}

