data "template_file" "init_worker" {
  count    = var.workers
  template = file("${path.module}/init_node.py")

  vars = {
    s3_bucket                 = ""
    region_name               = data.aws_region.current.name
    instance_index            = count.index
    vpc_name                  = local.dns_name
    cloudwatch_log_group      = var.cloudwatch_logs ? (var.cloudwatch_single_log_group ? local.dns_name : aws_cloudwatch_log_group.workers[count.index].name) : ""
    group                     = "worker"
    store_join_tokens_as_tags = var.store_join_tokens_as_tags ? 1 : 0
    ssh_authorization_method  = var.ssh_authorization_method
  }
}

data "cloudinit_config" "workers" {
  count         = var.workers
  gzip          = "true"
  base64_encode = "true"

  part {
    content = file("${path.module}/common.cloud-config")
  }

  part {
    filename     = "extra.cloud-config"
    content      = var.cloud_config_extra
    merge_type   = var.cloud_config_extra_merge_type
    content_type = "text/cloud-config"
  }

  part {
    filename     = "init_worker.py"
    content      = data.template_file.init_worker[count.index].rendered
    content_type = "text/x-shellscript"
  }
}

resource "aws_instance" "workers" {
  depends_on = [
    aws_instance.managers,
    aws_cloudwatch_log_group.workers,
    aws_cloudwatch_log_group.main,
  ]

  count         = var.workers
  ami           = var.worker_base_ami_id
  instance_type = local.instance_type_worker
  subnet_id     = aws_subnet.ms[count.index % length(local.availability_zones)].id
  private_ip = cidrhost(
    aws_subnet.ms[count.index % length(local.availability_zones)].cidr_block,
    100 + count.index,
  )

  vpc_security_group_ids = local.security_group_ids

  iam_instance_profile = aws_iam_instance_profile.ec2.name
  user_data_base64     = data.cloudinit_config.workers[count.index].rendered
  key_name             = var.key_name

  tags = {
    Name = "${var.name} worker ${count.index}"
    Role = "worker"
  }

  root_block_device {
    volume_size = var.volume_size
  }

  #  ebs_block_device {
  #    device_name = "xvdf"
  #    volume_size = var.swap_size
  #  }

  lifecycle {
    ignore_changes = [
      private_ip,
    ]
  }

  credit_specification {
    cpu_credits = "standard"
  }
}

resource "aws_cloudwatch_metric_alarm" "low-cpu-credit-workers" {
  count           = local.burstable_instance_type_worker ? var.workers : 0
  actions_enabled = true
  alarm_actions = flatten([
    var.sns_arn,
    var.additional_alarm_actions,
  ])
  alarm_name          = "${local.dns_name}-low-cpu-credit-worker${count.index}"
  comparison_operator = "LessThanThreshold"
  datapoints_to_alarm = 1
  dimensions = {
    "InstanceId" = aws_instance.workers[count.index].id
  }
  evaluation_periods        = 1
  insufficient_data_actions = []
  metric_name               = "CPUCreditBalance"
  namespace                 = "AWS/EC2"
  ok_actions                = []
  period                    = 300
  statistic                 = "Average"
  tags                      = {}
  threshold                 = 75
  treat_missing_data        = "missing"
}

resource "aws_cloudwatch_metric_alarm" "high-cpu-workers" {
  count           = var.workers
  actions_enabled = true
  alarm_actions = [
    var.sns_arn,
  ]
  alarm_name          = "${local.dns_name}-high-cpu-worker${count.index}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  datapoints_to_alarm = 5
  dimensions = {
    "InstanceId" = aws_instance.workers[count.index].id
  }
  evaluation_periods        = 5
  insufficient_data_actions = []
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  ok_actions                = []
  period                    = 60
  statistic                 = "Average"
  tags                      = {}
  threshold                 = 85
}

resource "aws_cloudwatch_log_group" "workers" {
  count             = (var.cloudwatch_logs && !var.cloudwatch_single_log_group) ? var.workers : 0
  name              = "${local.dns_name}-worker${count.index}"
  retention_in_days = var.cloudwatch_retention_in_days

  tags = {
    Environment = var.name
    Name        = "${var.name} worker ${count.index}"
    Node        = "${local.dns_name}-worker${count.index}"
  }
}

resource "aws_lb_target_group_attachment" "workers" {
  count            = var.workers
  target_group_arn = var.target_group
  target_id        = aws_instance.workers[count.index].id
}

