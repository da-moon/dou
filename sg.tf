## Security Group Config
resource "aws_security_group" "plm_dev" {
  name        = "${var.project_name}-sg"
  description = "VPC for ${var.project_name}"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = var.nsg_rule
    content {
      description = ingress.value[0]
      from_port   = ingress.value[1]
      to_port     = ingress.value[1]
      protocol    = "tcp"
      cidr_blocks = [ingress.value[2]]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "${var.project_name}-sg"
    Project = var.project_name
  }
}