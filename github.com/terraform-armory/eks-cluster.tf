module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version
  subnets         = module.vpc.private_subnets

  tags = {
    environment = var.environment
    project     = "Armory"
  }

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = var.instance_type
      additional_userdata           = "armory spinnaker ${var.environment}"
      asg_desired_capacity          = var.desired_capacity
      asg_max_size                  = var.max_size
      asg_min_size                  = var.min_size
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    }
  ]

  manage_aws_auth  = false
  write_kubeconfig = false
  # cluster_enabled_log_types = ["api", "authenticator", "controllerManager", "scheduler"]
}

resource "aws_autoscaling_schedule" "nonworkhours" {
  for_each               = toset(module.eks.workers_asg_names)
  scheduled_action_name  = "Non-working hours auto scale down"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  start_time             = "2021-10-04T03:00:00Z" # UTC/GTM only, equivalent to 2021-10-04T22:00:00Z
  recurrence             = "0 22 * * MON-FRI"
  time_zone              = "America/Mexico_City"
  autoscaling_group_name = each.key
  lifecycle {
    # Ignore changes at start_time as it get automatically changed after schedule is executed
    ignore_changes = [start_time]
  }
}

resource "aws_autoscaling_schedule" "workhours" {
  for_each               = toset(module.eks.workers_asg_names)
  scheduled_action_name  = "Working hours auto scale down"
  min_size               = var.min_size
  max_size               = var.max_size
  desired_capacity       = var.desired_capacity
  start_time             = "2021-10-04T11:00:00Z" # UTC/GTM only, equivalent to "2021-10-04T06:00:00Z"
  recurrence             = "0 6 * * MON-FRI"
  time_zone              = "America/Mexico_City"
  autoscaling_group_name = each.key
  lifecycle {
    # Ignore changes at start_time as it get automatically changed after schedule is executed
    ignore_changes = [start_time]
  }
}

resource "aws_iam_role_policy_attachment" "AmazonS3FullAccess" {
  role       = module.eks.worker_iam_role_name
  policy_arn = data.aws_iam_policy.AmazonS3FullAccess.arn
}

data "aws_iam_policy" "AmazonS3FullAccess" {
  name = "AmazonS3FullAccess"
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
