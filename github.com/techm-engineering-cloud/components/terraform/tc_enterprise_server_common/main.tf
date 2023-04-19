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

  part {
    content_type = "text/x-shellscript"
    filename     = "user_data.sh"
    content      = templatefile("${path.module}/user_data.sh", {
      machine_name = var.machine_name
    })
  }
}

resource "aws_instance" "active" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile
  subnet_id                   = var.active_subnet_id
  associate_public_ip_address = false
  key_name                    = var.ssh_key_name
  user_data_base64            = data.cloudinit_config.init.rendered

  vpc_security_group_ids = [
    var.enterprise_security_group_id
  ]

  tags = {
    Name = var.machine_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "standby" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile
  subnet_id                   = var.standby_subnet_id
  associate_public_ip_address = false
  key_name                    = var.ssh_key_name
  user_data_base64            = data.cloudinit_config.init.rendered

  vpc_security_group_ids = [
    var.enterprise_security_group_id
  ]

  tags = {
    Name = var.machine_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "null_resource" "stop_standby" {
  depends_on = [
    aws_instance.standby
  ]
  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
aws ec2 stop-instances --instance-ids "${aws_instance.standby.id}"
EOF
  }
}


resource "aws_cloudwatch_metric_alarm" "low-cpu-credit-enterprise" {
  actions_enabled = true
  alarm_actions = flatten([
    var.sns_arn,
    var.additional_alarm_actions,
  ])
  alarm_name          = "${var.machine_name}-low-cpu-credit-enterprise"
  comparison_operator = "LessThanThreshold"
  datapoints_to_alarm = 1
  dimensions = {
    "InstanceId" = aws_instance.active.id
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

resource "aws_cloudwatch_metric_alarm" "high-cpu-enterprise" {
  actions_enabled = true
  alarm_actions = [
    var.sns_arn,
  ]
  alarm_name          = "${var.machine_name}-high-cpu-enterprise"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  datapoints_to_alarm = 5
  dimensions = {
    "InstanceId" = aws_instance.active.id
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



resource "aws_cloudwatch_metric_alarm" "low-cpu-credit-enterprise-standby" {
  actions_enabled = true
  alarm_actions = flatten([
    var.sns_arn,
    var.additional_alarm_actions,
  ])
  alarm_name          = "${var.machine_name}-low-cpu-credit-enterprise-standby"
  comparison_operator = "LessThanThreshold"
  datapoints_to_alarm = 1
  dimensions = {
    "InstanceId" = aws_instance.standby.id
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

resource "aws_cloudwatch_metric_alarm" "high-cpu-enterprise-standby" {
  actions_enabled = true
  alarm_actions = [
    var.sns_arn,
  ]
  alarm_name          = "${var.machine_name}-high-cpu-enterprise-standby"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  datapoints_to_alarm = 5
  dimensions = {
    "InstanceId" = aws_instance.standby.id
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
