output "bastion_host" {
  value = module.ec2-instances.bastion_ip
}

output "master_host" {
  value = module.ec2-instances.master_private_ip
}

output "worker_hosts" {
  value = module.ec2-instances.workers_private_ip
}

