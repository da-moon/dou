### use this module if you intend to attach

# ALB
resource "aws_alb" "alb" {
  name            = "${var.service_name}-alb"
  internal        = true
  security_groups = [var.security_groups]
  subnets         = split(",", var.subnets)
  idle_timeout    = var.alb_idle_timeout

  tags = {
    env = var.run_env
    ## Adding servicename for Datadog filters to match other filters using "servicename" for other legacy apis.
    servicename = var.service_name
  }
}

##########################
#        DNS             #
##########################

resource "aws_route53_record" "dns_entry" {
  zone_id = var.hosted_zone_id
  name    = "${var.service_name}.${var.optional_subdomain}${data.aws_route53_zone.hosted_zone.name}"
  type    = "A"

  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = false
  }
}

data "aws_route53_zone" "hosted_zone" {
  zone_id      = var.hosted_zone_id
  private_zone = true
}

