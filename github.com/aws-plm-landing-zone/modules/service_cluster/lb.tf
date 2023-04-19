resource "aws_launch_template" "service_template" {
  name          = "${var.environment}-${var.project_name}-${var.service_name}"
  image_id      = data.aws_ami.service_ami.id
  instance_type = var.instance_type
  key_name      = var.instance_key_name

  user_data = base64encode(data.template_cloudinit_config.init.rendered)
  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.environment}-${var.service_name}-instance"
    }
  }

  vpc_security_group_ids = [aws_security_group.service-sg.id]

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 100
      volume_type = "gp2"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.environment}-${var.service_name}"
  }
}

# AUTOSCALING LOAD BALANCER
resource "aws_autoscaling_group" "asg" {
  name              = "${var.project_name}-${var.service_name}-asg"
  target_group_arns = aws_lb_target_group.service_target_group[*].arn

  launch_template {
    id = aws_launch_template.service_template.id
  }

  # Auto scaling group
  health_check_type         = "ELB"
  health_check_grace_period = var.health_check_grace_period
  vpc_zone_identifier       = var.private_instances ? var.private_subnets[*] : var.public_subnets[*]
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  wait_for_capacity_timeout = var.asg_wait_for_capacity_timeout
  force_delete              = true

  tags = [
    {
      key                 = "Environment"
      value               = "${var.project_name}-${var.service_name}-${var.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "${var.project_name}-${var.service_name}-project"
      propagate_at_launch = true
    },
  ]

}

# LOAD BALANCER #
resource "aws_lb" "service-lb" {
  name = "${var.service_name}-${var.project_name}-lb"

  internal           = false
  subnets            = var.private_instances ? var.private_subnets[*] : var.public_subnets[*]
  security_groups    = [aws_security_group.service-elb-sg.id]
  load_balancer_type = "application"

  tags = {
    Environment = var.environment
  }
}


resource "aws_lb_listener" "service_lb_listener" {
  count             = length(var.lb_listener_ports)
  load_balancer_arn = aws_lb.service-lb.arn
  port              = var.lb_listener_ports[count.index]
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_target_group[count.index].arn
  }
}


resource "aws_lb_target_group" "service_target_group" {
  count    = length(var.lb_listener_ports)
  name     = "${var.project_name}-${var.service_name}-asg-tg"
  port     = var.lb_listener_ports[count.index]
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = var.health_path
    protocol            = var.health_protocol
    matcher             = var.health_matcher
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.health_timeout
    interval            = var.health_interval

  }
}


##########################
#        DNS             #
##########################

resource "aws_route53_record" "dns_entry" {
  zone_id = var.hosted_zone_id
  name    = "${var.service_name}.${var.project_name}.${data.aws_route53_zone.hosted_zone.name}"
  type    = "A"

  alias {
    name                   = aws_lb.service-lb.dns_name
    zone_id                = aws_lb.service-lb.zone_id
    evaluate_target_health = false
  }

  depends_on = [aws_lb_listener.service_lb_listener]
}

data "aws_route53_zone" "hosted_zone" {
  zone_id      = var.hosted_zone_id
  private_zone = true
}
