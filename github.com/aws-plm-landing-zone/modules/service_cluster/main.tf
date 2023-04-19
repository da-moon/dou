##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}

data "aws_ami" "service_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["${var.ami_name}*"]
  }

  filter {
    name   = "root-device-type"
    values = [var.ami_root_device_type]
  }

  filter {
    name   = "virtualization-type"
    values = [var.ami_virtualization_type]
  }
}


##################################################################################
# RESOURCES
##################################################################################

# SECURITY GROUPS #
resource "aws_security_group" "service-elb-sg" {
  name   = "${var.project_name}_${var.service_name}_elb_sg"
  vpc_id = var.vpc_id

  dynamic ingress {
    for_each = var.lb_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  #allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Consul security group
resource "aws_security_group" "service-sg" {
  name   = "${var.project_name}_${var.service_name}_sg"
  vpc_id = var.vpc_id

  dynamic ingress {
    for_each = var.service_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
