# Get (externally configured) loadbalancer from spin deck deployment
data "aws_elb" "spin_deck" {
  for_each = var.deck_ingress_names
  name     = each.value
}

# Get (externally configured) loadbalancer from spin gate deployment
data "aws_elb" "spin_gate" {
  for_each = var.gate_ingress_names
  name     = each.value
}

resource "aws_route53_zone" "subdomain" {
  for_each = toset(var.subdomains)
  name     = "${each.key}.${var.base_dns_name}"

  tags = {
    Environment = each.key
    Terraform   = true
  }
}

resource "aws_route53_record" "subdomain" {
  for_each = toset(var.subdomains)
  zone_id  = data.aws_route53_zone.base.zone_id
  name     = aws_route53_zone.subdomain[each.key].name
  type     = "NS"
  ttl      = "30"
  records  = aws_route53_zone.subdomain[each.key].name_servers
}

resource "aws_route53_record" "deck" {
  for_each = var.deck_ingress_names
  zone_id  = aws_route53_zone.subdomain[each.key].zone_id
  name     = "spinnaker.${aws_route53_zone.subdomain[each.key].name}"
  type     = "CNAME"
  ttl      = "30"
  records  = [data.aws_elb.spin_deck[each.key].dns_name]
}

resource "aws_route53_record" "gate" {
  for_each = var.deck_ingress_names
  zone_id  = aws_route53_zone.subdomain[each.key].zone_id
  name     = "gate.${aws_route53_zone.subdomain[each.key].name}"
  type     = "CNAME"
  ttl      = "30"
  records  = [data.aws_elb.spin_gate[each.key].dns_name]
}