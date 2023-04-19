tfe-aws-alb-asg-pattern
Please Refer to WaaS Patterns for more details on this pattern and others supported.

This pattern has the ability to deploy the following resources below:

As this is a pattern that references multiple modules please review the links below
as this will have specific information for the individual modules themselves.

AWS Load Balancer
AWS Auto scaling group And Launch Template
Optional -

AWS FSX
Required variables
You can see full list of required and optional inputs under the inputs section below these are the REQUIRED only with example

Required For Data Lookup
Required or Likely Needed For Querying VPC, Subnets, SGs, KMS, Etc...

Name	Description	Type	Default	Required
account_name	Account Alias to build in	string		yes
alb_sg_name_search	Regex expression to search for SG names on ALB and retrieve its IDs	string	""	no
ec2_sg_name_search	Regex expression to search for SG names on EC2 and retrieve its IDs	string	""	no
os	OS options: windows, linux	string	n/a	yes
subnet_name	Subnet name options: app, web	string	"app"	yes
vault_role_name	Name of Vault Role to use	string		yes
iam_instance_profile	The IAM instance profile to associate with launched instances	string	"cfg-<appname>infrastructure-ec2-us-east-1"	yes
name	application name	string	n/a	yes
environment	App Environment (Dev/Test/QA/Prod/etc)	string	n/a	yes
mandatory_tags	Map with the mandatory tags	map(string)	{}	no
additional_tags	Map of Key-Value-Pairs describing any additional Tags to place on Resources	map(string)	{}	no
ebs_kms_key_alias	KMS key alias name. alias/ prefix is not needed.	string	""	no
Data Lookup Examples
iam_instance_profile            = "cfg-<appname>-infrastructure-ec2-us-east-1"
ec2_sg_name_search              = "<appname>-SYSID-05602-app"
alb_sg_name_search              = "<appname>-SYSID-05602-alb"
os                              = "linux"
account_name                    = "cfg-consumer-dev"
vault_role_name                 = "cfg-consumer-dev-<appname>-app-automation-role"
name                            = "sampleapp"
environment                     = "dev"
ebs_kms_key_alias               = "cfg-consumer-dev-ue1-<appname>-infrastructure-EBS-nonpci-cmk"
additional_tags = {
   "BackupPlan"      = "NonProd"
   "Patch Group"     = "rehydrate"
   "BusinessMapping" = "ABC"
}
mandatory_tags = {
   "Criticality"     = "Tier 3"
   "Requestor"       = "USER@companyA.com"
   "Support"         = "DL-<BusinessUnit>cCompanyA.com"
   "CostCenter"      = "RC1234567"
   "DataClass"       = "internal"
   "ApplicationID"   = "SYSID-12345"
   "applicationname" = "SampleApp"
   "assignmentgroup" = "AWS Platform Team"
}
Required For Application Load Balancer (HTTPS)
Name	Description	Type	Default	Required
https_listeners	A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-TLS-1-2-2017-01), target_group_index (defaults to https_listeners[count.index])	any	[]	yes
target_groups	A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port	any	[]	yes
ALB Example
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
        certificate_arn = <Your cert arn here>
        target_group_index   = 0
    }
]
Required For ASG/Launch Template
Name	Description	Type	Default	Required
min_size	The minimum size of the auto scale group	string	n/a	yes
max_size	The maximum size of the auto scale group	string	n/a	yes
desired_capacity	The number of Amazon EC2 instances that should be running in the group	string	n/a	yes
instance_type	The size of instance to launch	string	"t3.small"	no
ASG Example
instance_type                   = "t3.medium"
min_size                        = "2"
max_size                        = "3"
desired_capacity                = "2"
Requirements
Name	Version
terraform	>= 0.13.0
Providers
Name	Version
aws	n/a
template	n/a
Inputs
Name	Description	Type	Default	Required
account_name	Account Alias to build in	string	n/a	yes
additional_tags	Map of Key-Value-Pairs describing any additional Tags to place on Resources	map(string)	{}	no
alb_sg_name_search	Regex expression to search for SG names on ALB and retrieve its IDs	string	""	no
ami_name_tag	AMI name tag to override default AMI tag given after published AMI.	string	""	no
app_subnet_count	Number of app subnet IDs to retrieve. Options: 1,2,3	number	3	no
asg_subnet_count	Number of subnet IDs to retrieve. Options: 1,2,3	number	3	no
associate_public_ip_address	Associate a public ip address with an instance in a VPC.	bool	false	no
attributes	Additional attributes	list(string)	[]	no
automatic_backup_retention_days	Number of automatic backup retention days	string	"7"	no
block_device_mappings	Additional EBS block devices to attach to the instance	list(map(string))	
[
  {
    "delete_on_termination": "true",
    "device_name": "/dev/sdg",
    "volume_size": "40",
    "volume_type": "gp3"
  }
]
no
capacity_rebalance	Indicates whether capacity rebalance is enabled. Otherwise, capacity rebalance is disabled	string	"false"	no
create_asg	Whether to create autoscaling group.	bool	true	no
create_fsx	Flag used to create FSx	bool	false	no
create_lb	Controls if the Load Balancer should be created	bool	true	no
create_lt	Whether to create launch template	bool	true	no
credit_specification	Customize the credit specification of the instances	
object({
    cpu_credits = string
  })
null	no
deployment_type	Deployment type	string	"MULTI_AZ_1"	no
desired_capacity	The number of Amazon EC2 instances that should be running in the group	string	n/a	yes
disable_api_termination	If true, enables EC2 Instance Termination Protection.	bool	false	no
dns_ips	Default DNS IPs	list	
[
  "10.162.56.15",
  "10.162.57.11"
]
no
domain_name	Domain Name	string	"corp.internal.companyA.com"	no
drop_invalid_header_fields	Indicates whether invalid header fields are dropped in application load balancers.	bool	false	no
ebs_kms_key_alias	KMS key alias name. alias/ prefix is not needed.	string	""	no
ebs_optimized	If true, the launched EC2 instance will be EBS-optimized	bool	false	no
ec2_sg_name_search	Regex expression to search for SG names on EC2 and retrieve its IDs	string	""	no
enable_deletion_protection	If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer.	bool	false	no
enable_http2	Indicates whether HTTP/2 is enabled in application load balancers.	bool	true	no
environment	App Environment (Dev/Test/QA/Prod/etc)	string	n/a	yes
extra_ssl_certs	A list of maps describing any extra SSL certificates to apply to the HTTPS listeners. Required key/values: certificate_arn, https_listener_index (the index of the listener within https_listeners which the cert applies toward).	list(map(string))	[]	no
file_system_administrators_group	FS Admin Group	string	"DPT_FSx_Admin"	no
fsx_kms_key_alias	KMS key alias name. alias/ prefix is not needed.	string	""	no
fsx_sg_name_search	Regex expression to search for SG names on FSX and retrieve its IDs	string	""	no
fsx_subnet_count	Number of subnet IDs to retrieve. Options: 1,2,3	number	2	no
health_check_type	Controls how health checking is done. Values are - EC2 and ELB	string	"EC2"	no
http_tcp_listeners	A list of maps describing the HTTP listeners or TCP ports for this ALB. Required key/values: port, protocol. Optional key/values: target_group_index (defaults to http_tcp_listeners[count.index])	any	[]	no
https_listener_rules	A list of maps describing the Listener Rules for this ALB. Required key/values: actions, conditions. Optional key/values: priority, https_listener_index (default to https_listeners[count.index])	any	[]	no
https_listeners	A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-2016-08), target_group_index (defaults to https_listeners[count.index])	any	[]	no
iam_instance_profile	The IAM instance profile to associate with launched instances	string	"cfg-infrastructure-ec2-us-east-1"	no
idle_timeout	The time in seconds that the connection is allowed to be idle.	number	60	no
ingress	ingress vpc true or false	bool	false	no
instance_type	The size of instance to launch	string	"t3.small"	no
internal	Boolean determining if the load balancer is internal or externally facing.	bool	true	no
ip_address_type	The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack.	string	"ipv4"	no
keypair_name	The key name that should be used for the instance.	string	""	no
launch_template_version	Launch template version. Can be version number, $Latest or $Default	string	null	no
lb_subnet_count	Number of subnet IDs to retrieve. Options: 1,2,3	number	3	no
listener_ssl_policy_default	The security policy if using HTTPS externally on the load balancer.	string	"ELBSecurityPolicy-TLS-1-2-2017-01"	no
mandatory_tags	Map with the mandatory tags	map(string)	{}	no
max_size	The maximum size of the auto scale group	string	n/a	yes
min_elb_capacity	Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes	number	0	no
min_size	The minimum size of the auto scale group	string	n/a	yes
mixed_instances_policy	policy to used mixed group of on demand/spot of differing types. Launch template is automatically generated. https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html#mixed_instances_policy-1	
object({
    instances_distribution = object({
      on_demand_allocation_strategy            = string
      on_demand_base_capacity                  = number
      on_demand_percentage_above_base_capacity = number
      spot_allocation_strategy                 = string
      spot_instance_pools                      = number
      spot_max_price                           = string
    })
    override = list(object({
      instance_type     = string
      weighted_capacity = number
    }))
  })
{
  "instances_distribution": {
    "on_demand_allocation_strategy": "prioritized",
    "on_demand_base_capacity": "0",
    "on_demand_percentage_above_base_capacity": null,
    "spot_allocation_strategy": "capacity-optimized",
    "spot_instance_pools": null,
    "spot_max_price": null
  },
  "override": [
    {
      "instance_type": "t3.small",
      "weighted_capacity": null
    },
    {
      "instance_type": "t2.small",
      "weighted_capacity": null
    }
  ]
}
no
name	application name	string	n/a	yes
organizational_unit_distinguished_name	OU name	string	"OU=FSX,OU=AWS,OU=ServersSecure,OU=!Common,DC=corp,DC=internal,DC=companyA,DC=com"	no
os	OS options: windows, linux	string	n/a	yes
password	Password for Service Acct	string	null	no
placement	The placement specifications of the instances	
object({
    affinity          = string
    availability_zone = string
    group_name        = string
    host_id           = string
    tenancy           = string
  })
null	no
region	AWS Region	string	"us-east-1"	no
root_block_device	Customize details about the root block device of the instance	list(map(string))	[]	no
storage_capacity	Storage Capacity	string	""	no
storage_type	Storage type	string	""	no
subnet_name	Subnet name options: app, data, web	string	"app"	no
target_groups	A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port	any	[]	no
tfe_vpc_workspace	VPC TFE workspaces name without beginning string of: vpc-	string	null	no
throughput_capacity	Throrughput Capacity	string	""	no
user_data_vars	user data variables to pass	map(string)	{}	no
username	Service Account username	string	"SVC_AWS_FSx"	no
web_subnet_count	Number of web subnet IDs to retrieve: Options: 1,2,3	number	3	no
Outputs
Name	Description
autoscaling_group_arn	The ARN for this AutoScaling Group
autoscaling_group_name	The autoscaling group name
build_data	VPC related data retrieved by names. Ex: AMI Ids, KMS Key Ids, SGs.
identity_arn	The ARN for this current identity
lb_arn	The ID and ARN of the load balancer we created.
lb_id	The ID and ARN of the load balancer we created.
