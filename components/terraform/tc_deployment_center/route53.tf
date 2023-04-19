
data "aws_vpc_dhcp_options" "options" {
  dhcp_options_id = data.aws_vpc.main.dhcp_options_id
}

data "aws_route53_zone" "zone" {
  zone_id = var.hosted_zone_id
}

resource "aws_route53_record" "deployment_center_lb" {
  zone_id = var.hosted_zone_id
  name    = "dc.${data.aws_route53_zone.zone.name}"
  type    = "A"

  alias {
    name                   = aws_lb.deployment_center.dns_name
    zone_id                = aws_lb.deployment_center.zone_id
    evaluate_target_health = true
  }
}

