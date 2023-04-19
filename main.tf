# This module will provide automatic memory based scaling of ECS services
# This module does not expose configuration on how to scale (because it's complicated), instead it sets sensible defaults.

### Autoscaling Targets - The equivalent of an "Autoscaling Group", but for container services
resource "aws_appautoscaling_target" "task_autoscaling_target_memory" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = data.terraform_remote_state.config.outputs.ecs_scaling_role_arn
  min_capacity       = var.min_services_desired
  max_capacity       = var.max_services_desired
}

### Autoscaling Policies
### These guide how containers are scaled
resource "aws_appautoscaling_policy" "task_autoscaling_memory" {
  name               = "${var.service_name}_autoscaling_memory"
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"

  adjustment_type         = "PercentChangeInCapacity"
  cooldown                = 60 // 1 minute in between scales
  metric_aggregation_type = "Average"

  // If less than 30% memory Utilization, scale down
  step_adjustment {
    metric_interval_upper_bound = 30 - var.scaling_memory_threshold
    scaling_adjustment          = -25
  }

  # 30-65% - Dont scale
  step_adjustment {
    metric_interval_lower_bound = 30 - var.scaling_memory_threshold
    metric_interval_upper_bound = 65 - var.scaling_memory_threshold
    scaling_adjustment          = 0
  }

  # 65% - 85% - Scale up by 10%
  step_adjustment {
    metric_interval_lower_bound = 65 - var.scaling_memory_threshold
    metric_interval_upper_bound = 85 - var.scaling_memory_threshold
    scaling_adjustment          = 10
  }

  # Scale by 25% in > 85% memory Utilization
  step_adjustment {
    metric_interval_lower_bound = 85 - var.scaling_memory_threshold
    scaling_adjustment          = 25
  }

  depends_on = [aws_appautoscaling_target.task_autoscaling_target_memory]
}

# So if average memory utilization for all tasks is over the threshold for ${var.scaling_period} minutes, this will be triggered.
resource "aws_cloudwatch_metric_alarm" "task_autoscaling_memory" {
  alarm_name          = "${var.service_name}_autoscaling_target_memory"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "300" // Statistic gathered over past N seconds
  statistic           = "Average"

  // Alarm when more than threshold
  threshold = var.scaling_memory_threshold

  dimensions = {
    ServiceName = var.service_name
    ClusterName = var.cluster_name
  }

  alarm_description = "This metric monitors the memory for ${var.service_name} containers. It drives ${var.service_name} task scaling"

  /// We want this alarm to drive autoscaling, even when it is on OK status
  alarm_actions = [aws_appautoscaling_policy.task_autoscaling_memory.arn]
  ok_actions    = [aws_appautoscaling_policy.task_autoscaling_memory.arn]
}

