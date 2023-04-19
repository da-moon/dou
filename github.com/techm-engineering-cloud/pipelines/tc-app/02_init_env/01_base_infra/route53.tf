## Add route53 record for RDS db

resource "aws_route53_record" "db" {
  zone_id = jsondecode(data.aws_s3_object.core_outputs.body).private_hosted_zone_id
  name    = nonsensitive(data.aws_ssm_parameter.db_server.value)
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.base_rds.address]
}

####Route53 record for Solr indexing server

resource "aws_route53_record" "solr_indexing" {
  zone_id = jsondecode(data.aws_s3_object.core_outputs.body).private_hosted_zone_id
  name    = nonsensitive(data.aws_ssm_parameter.indexing_dns.value)
  type    = "A"

  alias {
    name                   = aws_lb.solr_indexing_lb_main.dns_name
    zone_id                = aws_lb.solr_indexing_lb_main.zone_id
    evaluate_target_health = true
  }
}

####Route53 record for web server

resource "aws_route53_record" "web" {
  zone_id = jsondecode(data.aws_s3_object.core_outputs.body).private_hosted_zone_id
  name    = nonsensitive(data.aws_ssm_parameter.web_dns.value)
  type    = "A"

  alias {
    name                   = aws_lb.webserver_lb_main.dns_name
    zone_id                = aws_lb.webserver_lb_main.zone_id
    evaluate_target_health = true
  }
}

####Route53 record for aw gateway

 resource "aws_route53_record" "aw_gateway" {
  count   = !local.is_web_aw_same_dns && data.aws_ssm_parameter.ms_orchestration.value == "Docker Swarm" ? 1 : 0
  zone_id = jsondecode(data.aws_s3_object.core_outputs.body).private_hosted_zone_id
  name    = nonsensitive(data.aws_ssm_parameter.aw_gateway_dns.value)
  type    = "A"

  alias {
    name                   = aws_lb.awg[0].dns_name
    zone_id                = aws_lb.awg[0].zone_id
    evaluate_target_health = true
  }
} 

