# Common variables for all TeamCenter environments
region = "us-east-1"

deployment_center = {
  folder_to_install = "DeploymentCenter_4.2.0.2"
  instance_type     = "t3.medium"
  backup_config = {
    enabled        = true
    cron_schedule  = "cron(0 11 ? * * *)"
    retention_days = 30
  }
}

software_repo_s3_uri = "s3://teamcenter-eic"

##Making public url as https 
is_https        = true ##set this to true and supply below 2 parameter values to make the public url as https
ssl_policy      = "ELBSecurityPolicy-2016-08"
certificate_arn = "arn:aws:acm:us-east-1:520983883852:certificate/73ba6084-a80c-41a1-b057-d51997dbcfba" ##ARN from Aws Certificate manager

##Deploy Teamcenter to an existing VPC (Uncomment when needed)
#vpc_id = ""

##Deploy with specific CIDR (Uncomment when needed)
#cidr_public_subnets        = []
#cidr_private_build_subnets = []

#domain name for private hosted zone
zone = "engcloud.com"

#self sign cert data
self_signed_cert = {
  country = "US" 
  state = "California" 
  locality = "San Francisco" 
  organization = "" 
  unit = "Internal" 
}
