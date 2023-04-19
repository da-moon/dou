### Tags ###
additional_tags = {
  "BackupPlan"      = "NonProd",
  "Patch Group"     = "rehydrate",
  "BusinessMapping" = "AWS"
}

mandatory_tags = {
  "Criticality"     = "Tier 3",
  "Requestor"       = "DL-CloudOperationsAWS@CompanyA.com",
  "Support"         = "DL-CloudOperationsAWS@CompanyA.com",
  "CostCenter"      = "2009160",
  "DataClass"       = "internal",
  "ApplicationID"   = "05602",
  "assignmentgroup" = "AWS Platform Team",
  "applicationname" = "tfe-aws-waas-alb-asg-pattern",
}

### App Variables ###
os           = "linux"
subnet_name  = "app"
name         = "samalbasg"
environment  = "dev"
account_name = "account-name-dev"

### App Automation Vault Role Name ###
vault_role_name = "example-tfe-test-automation-role" # "example-app-automation-role"

### ALB Variables ###
target_groups = [
  {
    backend_protocol = "HTTPS"
    backend_port     = 443
    target_type      = "instance"
  }
]

https_listeners = [
  {
    port               = 443
    protocol           = "HTTPS"
    certificate_arn    = "place arn certificate here"
    target_group_index = 0
  }
]

### ASG Vars ###
min_size             = "2"
max_size             = "2"
desired_capacity     = "2"
capacity_rebalance   = "true"
iam_instance_profile = "place iam instance profile here"
ebs_kms_key_alias    = "place alias here"

mixed_instances_policy = {
  instances_distribution = {
    on_demand_allocation_strategy            = "prioritized"
    on_demand_base_capacity                  = "2"
    on_demand_percentage_above_base_capacity = null
    spot_allocation_strategy                 = "capacity-optimized"

    #Only works with lowest price allocation strategy
    spot_instance_pools = null
    #Default: an empty string which means the on-demand price.
    spot_max_price = null
  }
  override = [{
    instance_type     = "t3.small"
    weighted_capacity = null
    }, {
    instance_type     = "t3.medium"
    weighted_capacity = null
  }]
}
