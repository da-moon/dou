### Example tfvars only, you can pull the variables needed from the pattern by navigating to this page https://confluence.corp.internal.companyA.com/display/CLSE/WaaS+Patterns and selecting the appropriate pattern ###

### Tags ###
additional_tags = {
  "BackupPlan" = "NonProd",
  "Patch Group" = "rehydrate",
  "BusinessMapping" = "ABC",
}

mandatory_tags = {
  "Criticality"     = "Tier 3",
  "Requestor"       = "UPDATEME@companyA.com",
  "Support"         = "UPDATEME@companyA.com",
  "CostCenter"      = "1234567",
  "DataClass"       = "internal",
  "ApplicationID"   = "12345",
  "applicationname" = "sampleapp",
  "assignmentgroup" = "From ServiceNow"
}

### App Variables ###
tfe_vpc_workspace               = "consumer-p2"
os                              = "linux"
subnet_name                     = "app"
name                            = "sampleapp"
environment                     = "dev"

### App Automation Vault Role Name ###
vault_role_name = "cfg-consumer-dev-cfg-cldsvc-<appname>-automation-role"

### ALB Variables ###
alb_sg_name_search              = "example-12345-*"
target_groups = [
    {
        backend_protocol = "HTTPS"
        backend_port     = 443
        target_type      = "instance"
    }
  ]

https_listeners = [
    {
        port = 443
        protocol = "HTTPS"
        certificate_arn = "arn:aws:acm:us-east-1:660023206487:certificate/98e7a57c-c3ce-4b13-9298-a957e315812f"
        target_group_index   = 0
    }
]

### ASG Variables ###
instance_type                   = "t3.medium"
key_name                        = "linuxKP_cfg-consumer-dev"
min_size                        = "2"
max_size                        = "3"
desired_capacity                = "2"
iam_instance_profile            = "cfg-infrastructure-ec2-us-east-1"
ec2_sg_name_search              = "example-12345-*"
