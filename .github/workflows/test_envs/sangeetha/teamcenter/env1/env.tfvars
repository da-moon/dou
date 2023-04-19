eks_instances = {
  min_instances = 2
  desired_instances = 2
  max_instances = 4
  instance_type = "m5.xlarge"
}
machines = {
  web_tier = {
    instance_type = "m5.large"
    min_instances = 2
    max_instances = 4
  }
  enterprise_tier = {
    instance_type = "m5.xlarge"
  }
  solr_indexing = {
    instance_type = "m5.large"
    min_instances = 2
    max_instances = 4
  }
  file_servers = {
    instance_type = "m5.large"
    min_instances = 2
    max_instances = 4
  }
  ms_manager = {
    instance_type = "m5.xlarge"
    instances = 1
  }
  ms_worker = {
    instance_type = "m5.2xlarge"
    instances = 1
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
  cron_schedule  = "cron(0 11 * * ? *)"
  retention_days = 1
}
