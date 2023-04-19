# This module will provide automatic CPU based scaling of ECS services
# This module does not expose configuration on how to scale (because it's complicated), instead it sets sensible defaults.

### Autoscaling Targets - The equivalent of an "Autoscaling Group", but for container services
resource "aws_appautoscaling_target" "task_autoscaling_target_cpu" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = data.terraform_remote_state.config.outputs.ecs_scaling_role_arn
  min_capacity       = var.min_services_desired
  max_capacity       = var.max_services_desired
}

### Autoscaling Policies
### These guide how containers are scaled
resource "aws_appautoscaling_policy" "task_autoscaling_cpu" {
  name               = "${var.service_name}_autoscaling_cpu"
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"

  adjustment_type         = "PercentChangeInCapacity"
  cooldown                = 60
  metric_aggregation_type = "Average"

  // If less than 10% CPU Utilization, scale down
  step_adjustment {
    metric_interval_upper_bound = 10 - var.scaling_cpu_threshold
    scaling_adjustment          = -25
  }

  # 10-45% - Dont scale
  step_adjustment {
    metric_interval_lower_bound = 10 - var.scaling_cpu_threshold
    metric_interval_upper_bound = 45 - var.scaling_cpu_threshold
    scaling_adjustment          = 0
  }

  # 45% - 75% - Scale up by 10%
  step_adjustment {
    metric_interval_lower_bound = 45 - var.scaling_cpu_threshold
    metric_interval_upper_bound = 75 - var.scaling_cpu_threshold
    scaling_adjustment          = 10
  }

  # Scale by 25% in > 75% CPU Utilization
  step_adjustment {
    metric_interval_lower_bound = 75 - var.scaling_cpu_threshold
    scaling_adjustment          = 25
  }

  depends_on = [aws_appautoscaling_target.task_autoscaling_target_cpu]
}

# So if average CPU utilization for all tasks is over the threshold for ${var.scaling_period} minutes, this will be triggered.
resource "aws_cloudwatch_metric_alarm" "task_autoscaling_cpu" {
  alarm_name          = "${var.service_name}_autoscaling_target_cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.metric_period // Statistic gathered over past N seconds
  statistic           = "Average"

  // Alarm when more than threshold
  threshold = var.scaling_cpu_threshold

  dimensions = {
    ServiceName = var.service_name
    ClusterName = var.cluster_name
  }

  alarm_description = "This metric monitors the CPU for ${var.service_name} containers. It drives ${var.service_name} task scaling"

  /// We want this alarm to drive autoscaling, even when it is on OK status
  alarm_actions = [aws_appautoscaling_policy.task_autoscaling_cpu.arn]
  ok_actions    = [aws_appautoscaling_policy.task_autoscaling_cpu.arn]
}

