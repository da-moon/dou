
locals {
  multi_az_deployment_count = var.multi_az_deployment ? 2 : 1
  private_subnets           = slice(var.private_subnets, 0, local.multi_az_deployment_count)
  public_subnets            = var.public_subnets
}
#tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group" "envoy_proxy" {
  description = "${var.app_name}-envoyProxy"
  count       = var.create_vpc ? 1 : 0

  name   = "${var.app_name}-sg-envoy-proxy-nlb-${var.stage_name}"
  vpc_id = var.vpcid

  # ingress to envoy proxy, gateway
  ingress {
    description = "TLS from VPC"
    from_port   = var.ingress_gateway_container_port
    to_port     = var.ingress_gateway_container_port
    protocol    = "tcp"
    cidr_blocks = var.private_networking ? local.private_subnets : local.public_subnets
  }

  egress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.envoy_proxy_egress_cidr_block
  }

  tags = {
    Name  = "sg-envoy-proxy-nlb-${var.app_name}"
    Stage = var.stage_name
  }
}

resource "aws_security_group" "onprem_access" {
  description = "${var.app_name}-onprem_access"
  count       = 0
  name        = "${var.app_name}-sg-onprem_access-${var.stage_name}"
  vpc_id      = var.vpcid

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "sg-onprem_access-${var.app_name}"
    Stage = var.stage_name
  }
}