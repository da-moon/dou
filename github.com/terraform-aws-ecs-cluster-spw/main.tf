#############
#  Cluster  #
#############

#testing

resource "aws_ecs_cluster" "cluster" {
  name = var.name
}

##############
# Cloud Init #
##############

data "template_file" "register_instance" {
  template = file("${path.module}/templates/register_instance.sh.tpl")
  vars = {
    name = var.name
  }
}

data "template_file" "setup_consul_registration" {
  template = file("${path.module}/templates/setup_consul_registration.sh.tpl")
  vars = {
    dns_ip            = var.dns_ip
    consul_client_key = var.consul_client_key
    datacenter        = "aws-${var.region}"
    consul_cluster    = var.consul_cluster
  }
}

data "template_file" "setup_datadog" {
  template = file("${path.module}/templates/setup_datadog.sh.tpl")
  vars = {
    datadog_enabled = var.datadog_enabled
    datadog_api_key = var.datadog_api_key
  }
}

data "template_cloudinit_config" "init" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "get_config.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.register_instance.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.setup_consul_registration.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.setup_datadog.rendered
  }
}

##########################
# Auto-scaling instances #
##########################

resource "aws_launch_configuration" "ecs" {
  image_id             = data.aws_ami.amazn_ami.image_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  security_groups      = split(",", var.security_groups)
  iam_instance_profile = var.iam_instance_profile
  enable_monitoring    = var.detailed_monitoring
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
  load_balancers            = compact(split(",", var.elb_names))
  max_size                  = var.desired_hosts
  min_size                  = var.desired_hosts
  desired_capacity          = var.desired_hosts
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  vpc_zone_identifier       = split(",", var.subnet_ids)
  tag {
    key                 = "Name"
    value               = "ecs-${var.name}"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "amazn_ami" {

   owners = ["amazon"]
   filter {
      name = "is-public"
      values = ["true"]
   }
   filter {
      name = "name"
      values = ["amzn-ami-2018.03*"]
   }
   filter {
      name = "architecture"
      values = ["x86_64"]
   }
   most_recent = true
}