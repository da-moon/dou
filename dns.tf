# Get (externally configured) hosted zone
data "aws_route53_zone" "base" {
  name = var.base_dns_name
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name = data.aws_route53_zone.base.name
  zone_id     = data.aws_route53_zone.base.zone_id

  subject_alternative_names = [
    "*.${data.aws_route53_zone.base.name}",
    "*.dev.${data.aws_route53_zone.base.name}",
    "*.stg.${data.aws_route53_zone.base.name}"
  ]

  wait_for_validation = true

  tags = {
    Name      = data.aws_route53_zone.base.name
    Terraform = true
  }
}