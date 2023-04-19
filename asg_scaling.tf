### General ECS Scaling ###

## High Memory Utilization CW Alarm
resource "aws_cloudwatch_metric_alarm" "ecs_cluster_high_memory_utilization" {
  alarm_name          = "ECS_${aws_ecs_cluster.cluster.name}_cluster_high_memory_utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"

  // Alarm when more X% memory utilization
  threshold = var.ecs_cluster_memory_utilization_high_threshold

  dimensions = {
    ClusterName = aws_ecs_cluster.cluster.name
  }

  alarm_description = "This metric monitors memory utilization. It also drives cluster scaling based on utilization."

  alarm_actions = [
    aws_autoscaling_policy.ecs_memory_utilization_scaling_policy_up.arn,
  ]
}

## Low Memory Utilization CW Alarm
resource "aws_cloudwatch_metric_alarm" "ecs_cluster_low_memory_utilization" {
  alarm_name          = "ECS_${aws_ecs_cluster.cluster.name}_cluster_low_memory_utilization"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"

  // Alarm when less X% memory utilization
  threshold = var.ecs_cluster_memory_utilization_lower_threshold

  dimensions = {
    ClusterName = aws_ecs_cluster.cluster.name
  }

  alarm_description = "This metric monitors memory utilization. It also drives cluster scaling based on utilization."

  alarm_actions = [
    aws_autoscaling_policy.ecs_memory_utilization_scaling_policy_down.arn,
  ]
}

#### ECS CPU Utilization CW Alarm

# The ASG will scale slowly based on CPU
resource "aws_cloudwatch_metric_alarm" "ecs_asg_cpu_high_utilization" {
  alarm_name          = "ECS_${aws_autoscaling_group.ecs.name}_asg_cpu_high_utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "600"
  statistic           = "Average"

  // Alarm when more X% CPU utilization
  threshold = var.ecs_cluster_asg_cpu_utilization_high_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ecs.name
  }

  alarm_description = "This metric monitors cpu utilization. It also drives cluster scaling based on utilization."

  /// We want this alarm to drive autoscaling, even when it is on OK status
  alarm_actions = [
    aws_autoscaling_policy.ecs_asg_cpu_utilization_scale_up_policy.arn,
  ]
}

resource "aws_cloudwatch_metric_alarm" "ecs_asg_cpu_low_utilization" {
  alarm_name          = "ECS_${aws_autoscaling_group.ecs.name}_asg_cpu_low_utilization"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "600"
  statistic           = "Average"

  // Alarm when more X% CPU utilization
  threshold = var.ecs_cluster_asg_cpu_utilization_low_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ecs.name
  }

  alarm_description = "This metric monitors cpu utilization. It also drives cluster scaling based on utilization."

  /// We want this alarm to drive autoscaling, even when it is on OK status
  alarm_actions = [
    aws_autoscaling_policy.ecs_asg_cpu_utilization_scale_down_policy.arn,
  ]
}

# The cluster's CPU utilization will drive rapid upscaling and slow downscaling.
resource "aws_cloudwatch_metric_alarm" "ecs_cluster_cpu_high_utilization" {
  alarm_name          = "ECS_${aws_ecs_cluster.cluster.name}_cluster_cpu_high_utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "120" // Average completed over past 180 seconds
  statistic           = "Average"

  // Alarm when more X% CPU utilization
  threshold = var.ecs_cluster_cpu_utilization_high_threshold

  dimensions = {
    ClusterName = aws_ecs_cluster.cluster.name
  }

  alarm_description = "This metric monitors cpu utilization. It also drives cluster scaling based on utilization."

  /// We want this alarm to drive autoscaling, even when it is on OK status
  alarm_actions = [
    aws_autoscaling_policy.ecs_cpu_utilization_scale_up_policy.arn,
  ]
}

resource "aws_cloudwatch_metric_alarm" "ecs_cluster_cpu_low_utilization" {
  alarm_name          = "ECS_${aws_ecs_cluster.cluster.name}_cluster_cpu_low_utilization"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "120" // Average completed over past 180 seconds
  statistic           = "Average"

  // Alarm when more X% CPU utilization
  threshold = var.ecs_cluster_cpu_utilization_low_threshold

  dimensions = {
    ClusterName = aws_ecs_cluster.cluster.name
  }

  alarm_description = "This metric monitors cpu utilization. It also drives cluster scaling based on utilization."

  /// We want this alarm to drive autoscaling, even when it is on OK status
  alarm_actions = [
    aws_autoscaling_policy.ecs_cpu_utilization_scale_down_policy.arn,
  ]
}

### ASG Scaling Policies ###
resource "aws_autoscaling_policy" "ecs_memory_utilization_scaling_policy_up" {
  name                      = "ecs-${aws_ecs_cluster.cluster.name}-cluster-asg-memory-utilization-scaling-policy-up"
  autoscaling_group_name    = aws_autoscaling_group.ecs.name
  adjustment_type           = "PercentChangeInCapacity"
  policy_type               = "StepScaling"
  estimated_instance_warmup = "300"
  metric_aggregation_type   = "Average"

  # Example: scale_up threshold is 70

  # Threshold + (0 to 10), [Eg: 70 to 80] don't scale up
  step_adjustment {
    scaling_adjustment          = 0
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = 10
  }

  # Threshold + (10 to 20), [Eg: 80 to 90] scale by 10%
  step_adjustment {
    scaling_adjustment          = 10
    metric_interval_lower_bound = 10
    metric_interval_upper_bound = 20
  }

  # Threshold + (20 above), [Eg: 90 and above] scale by 30%
  step_adjustment {
    scaling_adjustment          = 30
    metric_interval_lower_bound = 20
  }
}

resource "aws_autoscaling_policy" "ecs_memory_utilization_scaling_policy_down" {
  name                      = "ecs-${aws_ecs_cluster.cluster.name}-cluster-asg-memory-utilization-scaling-policy-down"
  autoscaling_group_name    = aws_autoscaling_group.ecs.name
  adjustment_type           = "PercentChangeInCapacity"
  policy_type               = "StepScaling"
  estimated_instance_warmup = "300"
  metric_aggregation_type   = "Average"

  # Example: scale_down threshold is 30

  # Threshold + (0 to -10), [Eg: 30 to 20] don't scale down
  step_adjustment {
    scaling_adjustment          = 0
    metric_interval_lower_bound = -10
    metric_interval_upper_bound = 0
  }

  # Threshold + (-10 to -20), [Eg: 20 to 10] scale down by 10%
  step_adjustment {
    scaling_adjustment          = -10
    metric_interval_lower_bound = -20
    metric_interval_upper_bound = -10
  }

  # Threshold + (-20 below), [Eg: 10 and below] scale down by 30%
  step_adjustment {
    scaling_adjustment          = -30
    metric_interval_upper_bound = -20
  }
}

resource "aws_autoscaling_policy" "ecs_asg_cpu_utilization_scale_up_policy" {
  name                      = "ecs-${aws_ecs_cluster.cluster.name}-asg-cluster-cpu-utilization-scale-up"
  autoscaling_group_name    = aws_autoscaling_group.ecs.name
  adjustment_type           = "PercentChangeInCapacity"
  policy_type               = "StepScaling"
  estimated_instance_warmup = "300"
  metric_aggregation_type   = "Average"

  # Example: scale_up threshold is 70

  # Threshold + (0 to 10), [Eg: 70 to 80] don't scale up
  step_adjustment {
    scaling_adjustment          = 0
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = 10
  }

  # Threshold + (10 to 20), [Eg: 80 to 90] scale by 10%
  step_adjustment {
    scaling_adjustment          = 10
    metric_interval_lower_bound = 10
    metric_interval_upper_bound = 20
  }

  # Threshold + (20 above), [Eg: 90 and above] scale by 30%
  step_adjustment {
    scaling_adjustment          = 30
    metric_interval_lower_bound = 20
  }
}

resource "aws_autoscaling_policy" "ecs_asg_cpu_utilization_scale_down_policy" {
  name                      = "ecs-${aws_ecs_cluster.cluster.name}-asg-cluster-cpu-utilization-scale-down"
  autoscaling_group_name    = aws_autoscaling_group.ecs.name
  adjustment_type           = "PercentChangeInCapacity"
  policy_type               = "StepScaling"
  estimated_instance_warmup = "300"
  metric_aggregation_type   = "Average"

  # Example: scale_down threshold is 30

  # Threshold + (0 to -10), [Eg: 30 to 20] don't scale down
  step_adjustment {
    scaling_adjustment          = 0
    metric_interval_lower_bound = -10
    metric_interval_upper_bound = 0
  }

  # Threshold + (-10 to -20), [Eg: 20 to 10] scale down by 10%
  step_adjustment {
    scaling_adjustment          = -10
    metric_interval_lower_bound = -20
    metric_interval_upper_bound = -10
  }

  # Threshold + (-20 below), [Eg: 10 and below] scale down by 30%
  step_adjustment {
    scaling_adjustment          = -30
    metric_interval_upper_bound = -20
  }
}

resource "aws_autoscaling_policy" "ecs_cpu_utilization_scale_up_policy" {
  name                      = "ecs-${aws_ecs_cluster.cluster.name}-cluster-cpu-utilization-scale-up"
  autoscaling_group_name    = aws_autoscaling_group.ecs.name
  adjustment_type           = "PercentChangeInCapacity"
  policy_type               = "StepScaling"
  estimated_instance_warmup = "180"
  metric_aggregation_type   = "Average"

  # Example: scale_up threshold is 70

  # Threshold + (0 to 10), [Eg: 70 to 80] don't scale up
  step_adjustment {
    scaling_adjustment          = 0
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = 10
  }

  # Threshold + (10 to 20), [Eg: 80 to 90] scale by 10%
  step_adjustment {
    scaling_adjustment          = 10
    metric_interval_lower_bound = 10
    metric_interval_upper_bound = 20
  }

  # Threshold + (20 above), [Eg: 90 and above] scale by 30%
  step_adjustment {
    scaling_adjustment          = 30
    metric_interval_lower_bound = 20
  }
}

resource "aws_autoscaling_policy" "ecs_cpu_utilization_scale_down_policy" {
  name                      = "ecs-${aws_ecs_cluster.cluster.name}-cluster-cpu-utilization-scale-down"
  autoscaling_group_name    = aws_autoscaling_group.ecs.name
  adjustment_type           = "PercentChangeInCapacity"
  policy_type               = "StepScaling"
  estimated_instance_warmup = "180"
  metric_aggregation_type   = "Average"

  # Example: scale_down threshold is 30

  # Threshold + (0 to -10), [Eg: 30 to 20] don't scale down
  step_adjustment {
    scaling_adjustment          = 0
    metric_interval_lower_bound = -10
    metric_interval_upper_bound = 0
  }

  # Threshold + (-10 to -20), [Eg: 20 to 10] scale down by 10%
  step_adjustment {
    scaling_adjustment          = -10
    metric_interval_lower_bound = -20
    metric_interval_upper_bound = -10
  }

  # Threshold + (-20 below), [Eg: 10 and below] scale down by 30%
  step_adjustment {
    scaling_adjustment          = -30
    metric_interval_upper_bound = -20
  }
}

