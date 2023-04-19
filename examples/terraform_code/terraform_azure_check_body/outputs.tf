
// output "consul_aws_elb_public_dns" {
//   value = module.consul_cluster.aws_elb_public_dns
// }

// output "vault_aws_elb_public_dns" {
//   value = module.vault_cluster.aws_elb_public_dns
// }

# output "ecs_aws_elb_public_dns" {
#   value = aws_lb.main.dns_name
# }

// output "s3_bucket_url" {
//   value = aws_s3_bucket.caas_bucket.bucket_domain_name
// }

// output "caas_security_groups" {
//   value = aws_security_group.caas_dev.id
// }

// output "vpc_id" {
//   value = module.vpc.vpc_id
// }

// output "public_subnet_id" {
//   value = [for s in aws_subnet.caas_public : s.id]
// }

// output "hosted_zone_id" {
//   value = data.aws_route53_zone.douterraform.zone_id
// }

// output "ecs_task_role_arn" {
//   value = aws_iam_role.ecs_task_role.arn
// }

// output "ecs_service_role" {
//   value = aws_iam_role.ecs_task_execution_role.arn
// }

// output "cass_cluster" {
//   value = aws_ecs_cluster.caas.id
// }

output "tls_private_key" { value = tls_private_key.example_ssh.private_key_pem }
output "public_ip_address" { value = azurerm_linux_virtual_machine.myterraformvm.public_ip_address }