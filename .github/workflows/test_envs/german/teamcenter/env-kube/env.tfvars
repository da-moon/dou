install_tc = true
eks_instances = {
  min_instances = 2
  desired_instances = 2
  max_instances = 4
  instance_type = "m5.xlarge"
}
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
  db = {
    instance_type = "db.m5.xlarge"
  }
  ms_manager = {
    instance_type = "m5.large"
    instances = 0
  }
  ms_worker = {
    instance_type = "m5.large"
    instances = 0
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

extra_kube_admin_role = "arn:aws:iam::520983883852:role/AWSReservedSSO_AdministratorAccess_4e7a854a03c51630"
