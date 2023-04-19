data "aws_availability_zones" "available" {}

data "aws_vpc" "main" {
  id = var.vpc_id
}
resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "${var.cluster_name}-policy"
  autoscaling_group_name = module.eks.eks_managed_node_groups_autoscaling_group_names[0]
  policy_type            = "TargetTrackingScaling"
    
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    
    target_value = 50.0
  }
  depends_on = [module.eks]
}
    
