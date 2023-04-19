############################
#  Auto-scaling instances  #
############################

resource "aws_launch_configuration" "ecs" {
  name_prefix   = "${aws_ecs_cluster.cluster.name}-asg-lc-"
  image_id      = var.cluster_ami
  instance_type = var.instance_type
  key_name      = var.deploy_key_pair

  security_groups = split(",", var.cluster_security_groups)

  iam_instance_profile = var.cluster_ecs_instance_profile_id
  user_data            = data.template_cloudinit_config.init.rendered

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs" {
  launch_configuration      = aws_launch_configuration.ecs.name
  max_size                  = var.cluster_max_hosts
  min_size                  = var.cluster_min_hosts
  desired_capacity          = var.cluster_min_hosts
  health_check_grace_period = "300"
  health_check_type         = "EC2"
  name                      = "ecs-${var.cluster_name}-asg"

  vpc_zone_identifier = split(",", var.cluster_subnet_ids)

  termination_policies = ["OldestLaunchConfiguration", "ClosestToNextInstanceHour"]
  enabled_metrics      = ["GroupInServiceInstances", "GroupPendingInstances", "GroupTerminatingInstances", "GroupTotalInstances"]

  tag {
    key                 = "Name"
    value               = "ecs-${var.cluster_name}-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "env"
    value               = var.run_env
    propagate_at_launch = true
  }

  tag {
    key                 = "service_name"
    value               = var.cluster_name
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}

