data "aws_key_pair" "key" {
  key_name           = var.ssh_key_name
  include_public_key = true
}

data "cloudinit_config" "init" {
  gzip          = "true"
  base64_encode = "true"

  part {
    content_type = "text/cloud-config"
    filename     = "cloud-config"
    content      = templatefile("${path.module}/cloud-config", {
      ssh_public_key = data.aws_key_pair.key.public_key
    })
  }
}

resource "aws_launch_configuration" "solr_indexing_server" {
  name_prefix          = var.installation_prefix != "" ? "${var.installation_prefix}-tc-solr-indexing-server-${var.env_name}" : "tc-solr-indexing-server-${var.env_name}"
  image_id             = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.ssh_key_name
  iam_instance_profile = var.iam_instance_profile
  security_groups      = [var.sl_security_group_id]
  user_data_base64     = data.cloudinit_config.init.rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "solr_indexing_server" {
  name                      = var.machine_name
  max_size                  = var.max_instances
  min_size                  = var.min_instances
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = var.min_instances
  force_delete              = false
  vpc_zone_identifier       = var.private_env_subnet_ids
  launch_configuration      = aws_launch_configuration.solr_indexing_server.name
  target_group_arns         = [var.sl_lb_target_group]

  tag {
    key                 = "Name"
    value               = var.machine_name
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "${var.machine_name}-policy"
  autoscaling_group_name = aws_autoscaling_group.solr_indexing_server.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}

