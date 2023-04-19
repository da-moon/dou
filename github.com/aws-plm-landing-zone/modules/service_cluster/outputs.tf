output "aws_elb_public_dns" {
  value = aws_lb.service-lb.dns_name
}
