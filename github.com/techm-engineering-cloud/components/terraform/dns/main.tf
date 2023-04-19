
data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_route53_zone" "private" {
  name = var.zone

  force_destroy = true  

  vpc {
    vpc_id = var.vpc_id
  }
}

