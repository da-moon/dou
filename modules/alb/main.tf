# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# code: language=terraform insertSpaces=true tabSize=2

#
# ──── SECURITY GROUP ────────────────────────────────────────────────
#

# ──── NOTE ──────────────────────────────────────────────────────────
# This is the group you need to edit if you want to
# restrict access to your application
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# ─────────────────────────────────────────────────────────────────────
resource "aws_security_group" "this" {
  name        = "${var.project_name}-ecs-alb"
  description = "controls access to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = var.ingress_cidr
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-ecs-application-loadbalancer-security-group"
  }
}

#
# ──── ALB ────────────────────────────────────────────────────────────
#

# ──── NOTE ──────────────────────────────────────────────────────────
# creates an application load balancer
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
# ─────────────────────────────────────────────────────────────────────
resource "aws_lb" "this" {
  depends_on = [
    aws_security_group.this,
  ]
  name            = "${var.project_name}-ecs-lb"
  subnets         = var.public_subnet_ids
  security_groups = ["${aws_security_group.this.id}"]
  internal        = false
  # internal           = true
  load_balancer_type = "application"
  # [ TODO ] should we store access logs in aws bucket ?
  #  access_logs {
  #    bucket  = aws_s3_bucket.lb_logs.bucket
  #    [ NOTE ] Logs are stored in the root if not configured
  #    prefix  = "${var.project_name}-ecs-alb"
  #    enabled = true
  #  }
  tags = {
    Name = "${var.project_name}-ecs-application-loadbalancer"
  }
}
# ──── NOTE ──────────────────────────────────────────────────────────
# Provides a Target Group resource for use with Load Balancer resources.
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
# ─────────────────────────────────────────────────────────────────────
resource "aws_lb_target_group" "this" {
  name        = "${var.project_name}-ecs-lb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    matcher  = "200,301,302"
    path     = var.health_check_path
    interval = "30"
    protocol = "HTTP"
    timeout  = "5"
  }
  tags = {
    Name = "${var.project_name}-ecs-application-loadbalancer-target-group"
  }
}
# ──── NOTE ──────────────────────────────────────────────────────────
# Redirect all traffic from the ALB to the target group
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
# ─────────────────────────────────────────────────────────────────────
resource "aws_lb_listener" "this" {
  depends_on = [
    aws_security_group.this,
    aws_lb.this,
    aws_lb_target_group.this,
  ]
  load_balancer_arn = aws_lb.this.arn
  # port              = 443
  # protocol          = "HTTPS"
  # certificate_arn   = data.aws_acm_certificate.this.arn
  port     = "80"
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.this.id
    type             = "forward"
  }
  tags = {
    Name = "${var.project_name}-ecs-application-loadbalancer"
  }
}

