### General ECS Scaling ###

## Memory Utilization CW Alarm
resource "aws_cloudwatch_metric_alarm" "ecs_cluster_memory_utilization" {
  alarm_name          = "ECS_${aws_ecs_cluster.cluster.name}_cluster_memory_utilization_for_scaling"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"

  // Alarm when more X% memory utilization
  threshold = var.ecs_cluster_memory_utilization_threshold

  dimensions = {
    ClusterName = aws_ecs_cluster.cluster.name
  }

  alarm_description = "This metric monitors memory utilization. It also drives cluster scaling based on utilization."

  /// We want this alarm to drive autoscaling, even when it is on OK status
  alarm_actions = [
    aws_autoscaling_policy.ecs_memory_utilization_scaling_policy.arn,
  ]

  ok_actions = [
    aws_autoscaling_policy.ecs_memory_utilization_scaling_policy.arn,
  ]
}

#### ECS CPU Utilization CW Alarm

# The ASG will scale slowly based on CPU
resource "aws_cloudwatch_metric_alarm" "ecs_asg_cpu_utilization" {
  alarm_name          = "ECS_${aws_autoscaling_group.ecs.name}_asg_cpu_utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "600"
  statistic           = "Average"

  // Alarm when more X% CPU utilization
  threshold = var.ecs_cluster_asg_cpu_utilization_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ecs.name
  }

  alarm_description = "This metric monitors cpu utilization. It also drives cluster scaling based on utilization."

  /// We want this alarm to drive autoscaling, even when it is on OK status
  alarm_actions = [
    aws_autoscaling_policy.ecs_asg_cpu_utilization_scaling_policy.arn,
  ]

  ok_actions = [
    aws_autoscaling_policy.ecs_asg_cpu_utilization_scaling_policy.arn,
  ]
}

# The cluster's CPU utilization will drive rapid upscaling and slow downscaling.
resource "aws_cloudwatch_metric_alarm" "ecs_cluster_cpu_utilization" {
  alarm_name          = "ECS_${aws_ecs_cluster.cluster.name}_cluster_cpu_utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "120" // Average completed over past 180 seconds
  statistic           = "Average"

  // Alarm when more X% CPU utilization
  threshold = var.ecs_cluster_cpu_utilization_threshold

  dimensions = {
    ClusterName = aws_ecs_cluster.cluster.name
  }

  alarm_description = "This metric monitors cpu utilization. It also drives cluster scaling based on utilization."

  /// We want this alarm to drive autoscaling, even when it is on OK status
  alarm_actions = [
    aws_autoscaling_policy.ecs_cpu_utilization_scaling_policy.arn,
  ]

  ok_actions = [
    aws_autoscaling_policy.ecs_cpu_utilization_scaling_policy.arn,
  ]
}

### ASG Scaling Policies ###
resource "aws_autoscaling_policy" "ecs_memory_utilization_scaling_policy" {
  name                      = "ecs-${aws_ecs_cluster.cluster.name}-cluster-asg-memory-utilization-scaling-policy"
  autoscaling_group_name    = aws_autoscaling_group.ecs.name
  adjustment_type           = "PercentChangeInCapacity"
  policy_type               = "StepScaling"
  estimated_instance_warmup = "300"
  metric_aggregation_type   = "Average"

  # 0-60% don't scale
  step_adjustment {
    scaling_adjustment          = 0
    metric_interval_upper_bound = 60 - var.ecs_cluster_memory_utilization_threshold
  }

  # 60-90% scale by 10%
  step_adjustment {
    scaling_adjustment          = 10
    metric_interval_lower_bound = 60 - var.ecs_cluster_memory_utilization_threshold
    metric_interval_upper_bound = 90 - var.ecs_cluster_memory_utilization_threshold
  }

  # Between 90 and 100 memory utilization, scale by 30%
  step_adjustment {
    scaling_adjustment          = 30
    metric_interval_lower_bound = 90 - var.ecs_cluster_memory_utilization_threshold
  }
}

resource "aws_autoscaling_policy" "ecs_asg_cpu_utilization_scaling_policy" {
  name                      = "ecs-${aws_ecs_cluster.cluster.name}-asg-cluster-cpu-utilization-scaling-policy"
  autoscaling_group_name    = aws_autoscaling_group.ecs.name
  adjustment_type           = "PercentChangeInCapacity"
  policy_type               = "StepScaling"
  estimated_instance_warmup = "300"
  metric_aggregation_type   = "Average"

  # 0 - 50% don't scale
  step_adjustment {
    scaling_adjustment          = 0
    metric_interval_upper_bound = 50 - var.ecs_cluster_asg_cpu_utilization_threshold
  }

  # 50 - 90% scale by 10%
  step_adjustment {
    scaling_adjustment          = 10
    metric_interval_lower_bound = 50 - var.ecs_cluster_asg_cpu_utilization_threshold
    metric_interval_upper_bound = 95 - var.ecs_cluster_asg_cpu_utilization_threshold
  }

  # Between 95 and 100 cpu utilization, scale by 30%
  step_adjustment {
    scaling_adjustment          = 30
    metric_interval_lower_bound = 95 - var.ecs_cluster_asg_cpu_utilization_threshold
  }
}

resource "aws_autoscaling_policy" "ecs_cpu_utilization_scaling_policy" {
  name                      = "ecs-${aws_ecs_cluster.cluster.name}-cluster-cpu-utilization-scaling-policy"
  autoscaling_group_name    = aws_autoscaling_group.ecs.name
  adjustment_type           = "PercentChangeInCapacity"
  policy_type               = "StepScaling"
  estimated_instance_warmup = "180"
  metric_aggregation_type   = "Average"

  # Below 15%, scale down by 10%
  step_adjustment {
    scaling_adjustment          = -10
    metric_interval_upper_bound = 15 - var.ecs_cluster_cpu_utilization_threshold
  }

  # 15 - 30% don't scale
  step_adjustment {
    scaling_adjustment          = 0
    metric_interval_lower_bound = 15 - var.ecs_cluster_cpu_utilization_threshold
    metric_interval_upper_bound = 35 - var.ecs_cluster_cpu_utilization_threshold
  }

  # 35 - 60% scale by 10%
  step_adjustment {
    scaling_adjustment          = 10
    metric_interval_lower_bound = 35 - var.ecs_cluster_cpu_utilization_threshold
    metric_interval_upper_bound = 60 - var.ecs_cluster_cpu_utilization_threshold
  }

  # 60 - 95% scale by 35%
  step_adjustment {
    scaling_adjustment          = 35
    metric_interval_lower_bound = 60 - var.ecs_cluster_cpu_utilization_threshold
    metric_interval_upper_bound = 95 - var.ecs_cluster_cpu_utilization_threshold
  }

  # Between 95 and 100 cpu utilization, scale by 50%
  step_adjustment {
    scaling_adjustment          = 50
    metric_interval_lower_bound = 95 - var.ecs_cluster_cpu_utilization_threshold
  }
}

