
locals {
  is_web_aw_same_dns     = data.aws_ssm_parameter.web_dns.value == data.aws_ssm_parameter.aw_gateway_dns.value
  is_web_aw_same_machine = data.aws_ssm_parameter.aw_gateway_machine.value == data.aws_ssm_parameter.web_machine.value
}

resource "aws_security_group" "solr_indexing_lb" {
  name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-solr-lb-sg" : "tc-${var.env_name}-solr-lb-sg"
  description = "Security group attached to solr-indexing load balancer"
  vpc_id      = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id

  ingress {
    description = "HTTP from VPC"
    from_port   = 8983
    to_port     = 8983
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
    Name = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-solr-lb-sg" : "tc-${var.env_name}-solr-lb-sg"
  }
}

resource "aws_lb" "solr_indexing_lb_main" {
  name                       = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-solr" : "tc-${var.env_name}-solr"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.solr_indexing_lb.id]
  subnets                    = [aws_subnet.env_subnet_1.id, aws_subnet.env_subnet_2.id]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "solr_indexing_lb_tg" {
  name                 = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-solr-lb-tg" : "tc-${var.env_name}-solr-lb-tg"
  port                 = 8983
  protocol             = "HTTP"
  vpc_id               = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id
  deregistration_delay = 30

  health_check {
    enabled           = true
    port              = 8983
    protocol          = "HTTP"
    path              = "/solr/"
    healthy_threshold = 2
    interval          = 15
    matcher           = "200-299,400-499"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.solr_indexing_lb_main.arn
  port              = "8983"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.solr_indexing_lb_tg.arn
  }
}
// ================================ webserver ==============================

resource "aws_security_group" "webserver_lb" {
  name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-webserver-lb-sg" : "tc-${var.env_name}-webserver-lb-sg"
  description = "Security group attached to webserver load balancer"
  vpc_id      = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id

  ingress {
    description      = "Web tier traffic from anywhere"
    from_port        = nonsensitive(data.aws_ssm_parameter.web_port.value)
    to_port          = nonsensitive(data.aws_ssm_parameter.web_port.value)
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  dynamic "ingress" {
    for_each = local.is_web_aw_same_dns ? [1] : []
    content {
      description      = "Active workspace gateway traffic from anywhere"
      from_port        = nonsensitive(data.aws_ssm_parameter.aw_gateway_port.value)
      to_port          = nonsensitive(data.aws_ssm_parameter.aw_gateway_port.value)
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-webserver-lb-sg" : "tc-${var.env_name}-webserver-lb-sg"
  }
}

resource "aws_lb" "webserver_lb_main" {
  name                       = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-webserver" : "tc-${var.env_name}-webserver"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.webserver_lb.id]
  subnets                    = jsondecode(data.aws_s3_object.core_outputs.body).public_subnet_ids
  enable_deletion_protection = false
  preserve_host_header       = true
}

resource "aws_lb_target_group" "webserver_lb_tg" {
  name                 = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-ws-lb-tg" : "tc-${var.env_name}-ws-lb-tg"
  port                 = 8080 # This is a constant port even if using SSL
  protocol             = "HTTP"
  vpc_id               = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id
  deregistration_delay = 30

  health_check {
    enabled           = true
    port              = 8080
    protocol          = "HTTP"
    path              = "/tc/controller/test"
    healthy_threshold = 2
    interval          = 15
  }

  stickiness {
    cookie_duration = 86400
    cookie_name     = "JSESSIONID"
    enabled         = true
    type            = "app_cookie"
  }
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.webserver_lb_main.arn
  port              = nonsensitive(data.aws_ssm_parameter.web_port.value)
  protocol          = upper(nonsensitive(data.aws_ssm_parameter.web_protocol.value))
  ssl_policy        = data.aws_ssm_parameter.web_protocol.value == "https" ? var.ssl_policy : ""
  certificate_arn   = data.aws_ssm_parameter.web_protocol.value == "https" ? jsondecode(data.aws_s3_object.core_outputs.body).self_signed_cert_arn : ""

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver_lb_tg.arn
  }
}

// ================================ AW Gateway ==============================

resource "aws_security_group" "awg" {
  count       = local.is_web_aw_same_dns ? 0 : 1
  name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-aw-gateway-lb-sg" : "tc-${var.env_name}-aw-gateway-lb-sg"
  description = "Security group attached to active workspace gateway load balancer"
  vpc_id      = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id

  ingress {
    description      = "Active workspace gateway traffic from anywhere"
    from_port        = nonsensitive(data.aws_ssm_parameter.aw_gateway_port.value)
    to_port          = nonsensitive(data.aws_ssm_parameter.aw_gateway_port.value)
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description = "Microservice"
    from_port   = nonsensitive(data.aws_ssm_parameter.ms_port.value)
    to_port     = nonsensitive(data.aws_ssm_parameter.ms_port.value)
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }
  dynamic "ingress" {
    for_each = var.is_https ? [1] : []
    content {
      description      = "SSL traffic"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-aw-gateway-lb-sg" : "tc-${var.env_name}-aw-gateway-lb-sg"
  }
}

 resource "aws_lb" "awg" {
  count                      = !local.is_web_aw_same_dns && data.aws_ssm_parameter.ms_orchestration.value == "Docker Swarm" ? 1 : 0
  name                       = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-aw-gateway" : "tc-${var.env_name}-aw-gateway"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.awg[0].id]
  subnets                    = jsondecode(data.aws_s3_object.core_outputs.body).public_subnet_ids
  enable_deletion_protection = false
  idle_timeout               = 3600
} 

resource "aws_lb_target_group" "awg" {
  count                = !local.is_web_aw_same_dns && data.aws_ssm_parameter.ms_orchestration.value == "Docker Swarm" ? 1 : 0
  name                 = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-aw-gw-lb-tg" : "tc-${var.env_name}-aw-gw-lb-tg"
  port                 = nonsensitive(data.aws_ssm_parameter.aw_gateway_port.value)
  protocol             = "HTTP"
  vpc_id               = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id
  deregistration_delay = 30

  health_check {
    enabled           = true
    port              = nonsensitive(data.aws_ssm_parameter.aw_gateway_port.value)
    protocol          = "HTTP"
    path              = "/ping"
    healthy_threshold = 2
    interval          = 15
  }

  stickiness {
    cookie_duration = 86400
    enabled         = true
    type            = "lb_cookie"
  }
}

 resource "aws_lb_listener" "awg" {
  count             = !local.is_web_aw_same_dns && data.aws_ssm_parameter.ms_orchestration.value == "Docker Swarm" ? 1 : 0
  load_balancer_arn = aws_lb.awg[0].arn
  port              = nonsensitive(data.aws_ssm_parameter.aw_gateway_port.value)
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.awg[0].arn
  }
} 

##HTTPS enabled
resource "aws_lb_listener" "awg_https" {
  count             = !local.is_web_aw_same_dns && var.is_https && data.aws_ssm_parameter.ms_orchestration.value == "Docker Swarm" ? 1 : 0
  load_balancer_arn = aws_lb.awg[0].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.awg[0].arn
  }
} 

