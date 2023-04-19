machines = {
  web_tier = {
    instance_type = "m5.large"
    min_instances = 1
    max_instances = 1
  }
  enterprise_tier = {
    instance_type = "m5.large"
  }
  solr_indexing = {
    instance_type = "m5.large"
    min_instances = 0
    max_instances = 1
  }
  file_servers = {
    instance_type = "m5.large"
    min_instances = 0
    max_instances = 1
  }
  ms_manager = {
    instance_type = "m5.large"
    instances     = 1
  }
  ms_worker = {
    instance_type = "m5.large"
    instances     = 0
  }
  db = {
    instance_type = "db.m5.xlarge"
  }
  build_server = {
    instance_type = "m5.large"
  }
}

##env specific backup configuration
env_backup_config = {
  enabled        = true
  cron_schedule  = "cron(0 11 ? * * *)"
  retention_days = 30
}


# #CIDR ranges for env and Swarm cluster in a specific VPC(uncomment when needed)
# env_cidr_private_subnets   = []
# swarm_cidr_private_subnets = []
