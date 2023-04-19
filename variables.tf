### Region To Build - Default us-east-1 ###
# tflint-ignore: terraform_unused_declarations
variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}
### DATA VARIABLES

variable "environment" {
  description = "App Environment (Dev/Test/QA/Prod/etc)"
  type        = string
}

### TAGS VARIABLES

variable "attributes" {
  description = "Additional attributes"
  type        = list(string)
  default     = []
}

variable "name" {
  description = "application name"
  type        = string
}

variable "mandatory_tags" {
  description = "Map with the mandatory tags"
  type        = map(string)
  default     = {}
}

variable "additional_tags" {
  description = "Map of Key-Value-Pairs describing any additional Tags to place on Resources"
  type        = map(string)
  default     = {}
}

## LB VARIABLES

variable "create_lb" {
  description = "Controls if the Load Balancer should be created"
  type        = bool
  default     = true
}

variable "lb_subnet_count" {
  type        = number
  default     = 3
  description = "Number of subnet IDs to retrieve. Options: 1,2,3"
}

variable "drop_invalid_header_fields" {
  description = "Indicates whether invalid header fields are dropped in application load balancers."
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer."
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Indicates whether HTTP/2 is enabled in application load balancers. "
  type        = bool
  default     = true
}

variable "extra_ssl_certs" {
  description = "A list of maps describing any extra SSL certificates to apply to the HTTPS listeners. Required key/values: certificate_arn, https_listener_index (the index of the listener within https_listeners which the cert applies toward)."
  type        = list(map(string))
  default     = []
}

variable "http_tcp_listeners" {
  description = "A list of maps describing the HTTP listeners or TCP ports for this ALB. Required key/values: port, protocol. Optional key/values: target_group_index (defaults to http_tcp_listeners[count.index])"
  type        = any
  default     = []
}

variable "https_listener_rules" {
  description = "A list of maps describing the Listener Rules for this ALB. Required key/values: actions, conditions. Optional key/values: priority, https_listener_index (default to https_listeners[count.index])"
  type        = any
  default     = []
}

variable "https_listeners" {
  description = "A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-2016-08), target_group_index (defaults to https_listeners[count.index])"
  type        = any
  default     = []
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle. "
  type        = number
  default     = 60
}

variable "internal" {
  description = "Boolean determining if the load balancer is internal or externally facing."
  type        = bool
  default     = true
}

variable "ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack. "
  type        = string
  default     = "ipv4"
}

variable "listener_ssl_policy_default" {
  description = "The security policy if using HTTPS externally on the load balancer."
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port"
  type        = any
  default     = []
}

## ASG VARIABLES

variable "asg_subnet_count" {
  type        = number
  default     = 3
  description = "Number of subnet IDs to retrieve. Options: 1,2,3"
}

variable "user_data_vars" {
  description = "user data variables to pass"
  type        = map(string)
  default     = {}
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC."
  type        = bool
  default     = false
}

variable "block_device_mappings" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(map(string))
  default = [
    {
      device_name           = "/dev/sdg"
      volume_size           = "40"
      volume_type           = "gp3"
      delete_on_termination = "true"
    }
  ]
}

variable "capacity_rebalance" {
  description = "Indicates whether capacity rebalance is enabled. Otherwise, capacity rebalance is disabled"
  type        = string
  default     = "false"
}

variable "create_asg" {
  description = "Whether to create autoscaling group."
  type        = bool
  default     = true
}

variable "create_lt" {
  description = "Whether to create launch template"
  type        = bool
  default     = true
}

variable "credit_specification" {
  description = "Customize the credit specification of the instances"

  type = object({
    cpu_credits = string
  })

  default = null
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  type        = string
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection."
  type        = bool
  default     = false
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = false
}

variable "health_check_type" {
  description = "Controls how health checking is done. Values are - EC2 and ELB"
  type        = string
  default     = "EC2"
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with launched instances"
  type        = string
  default     = "cfg-infrastructure-ec2-us-east-1"
}

variable "instance_type" {
  description = "The size of instance to launch"
  type        = string
  default     = "t3.small"
}

variable "keypair_name" {
  description = "The key name that should be used for the instance."
  type        = string
  default     = ""
}

variable "launch_template_version" {
  description = "Launch template version. Can be version number, $Latest or $Default"
  type        = string
  default     = null
}

variable "max_size" {
  description = "The maximum size of the auto scale group"
  type        = string
}

variable "min_elb_capacity" {
  description = "Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes"
  type        = number
  default     = 0
}

variable "min_size" {
  description = "The minimum size of the auto scale group"
  type        = string
}

variable "mixed_instances_policy" {
  description = "policy to used mixed group of on demand/spot of differing types. Launch template is automatically generated. https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html#mixed_instances_policy-1"

  type = object({
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
  default = {
    instances_distribution = {
      on_demand_allocation_strategy            = "prioritized"
      on_demand_base_capacity                  = "0"
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
      instance_type     = "t2.small"
      weighted_capacity = null
    }]
  }
}

variable "placement" {
  description = "The placement specifications of the instances"

  type = object({
    affinity          = string
    availability_zone = string
    group_name        = string
    host_id           = string
    tenancy           = string
  })

  default = null
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance"
  type        = list(map(string))
  default     = []
}

#datsource module
variable "tfe_vpc_workspace" {
  description = "VPC TFE workspaces name without beginning string of: vpc-"
  type        = string
  default     = null
}

variable "account_name" {
  type        = string
  description = "Account Alias to build in"
}

variable "ec2_sg_name_search" {
  default     = ""
  type        = string
  description = "Regex expression to search for SG names on EC2 and retrieve its IDs"
}

variable "alb_sg_name_search" {
  description = "Regex expression to search for SG names on ALB and retrieve its IDs"
  type        = string
  default     = ""
}

variable "fsx_sg_name_search" {
  default     = ""
  type        = string
  description = "Regex expression to search for SG names on FSX and retrieve its IDs"
}

variable "os" {
  type        = string
  description = "OS options: windows, linux"
}

variable "ami_name_tag" {
  description = "AMI name tag to override default AMI tag given after published AMI."
  type        = string
  default     = ""
}

variable "subnet_name" {
  type        = string
  default     = "app"
  description = "Subnet name options: app, data, web"
}

variable "ingress" {
  description = "ingress vpc true or false"
  default     = false
  type        = bool
}

variable "app_subnet_count" {
  description = "Number of app subnet IDs to retrieve. Options: 1,2,3"
  type        = number
  default     = 3
}

variable "web_subnet_count" {
  type        = number
  default     = 3
  description = "Number of web subnet IDs to retrieve: Options: 1,2,3"
}

variable "ebs_kms_key_alias" {
  type        = string
  default     = ""
  description = "KMS key alias name. alias/ prefix is not needed."
}

variable "fsx_kms_key_alias" {
  type        = string
  default     = ""
  description = "KMS key alias name. alias/ prefix is not needed."
}

### FSX Variables ###

variable "automatic_backup_retention_days" {
  type        = string
  default     = "7"
  description = "Number of automatic backup retention days"
}

variable "create_fsx" {
  type        = bool
  default     = false
  description = "Flag used to create FSx"
}

variable "deployment_type" {
  type        = string
  default     = "MULTI_AZ_1"
  description = "Deployment type"
}

variable "dns_ips" {
  type        = list
  default     = ["10.162.56.15", "10.162.57.11"]
  description = "Default DNS IPs"
}

variable "domain_name" {
  type        = string
  default     = "corp.internal.companyA.com"
  description = "Domain Name"
}

variable "file_system_administrators_group" {
  type        = string
  default     = "DPT_FSx_Admin"
  description = "FS Admin Group"
}

variable "organizational_unit_distinguished_name" {
  type        = string
  default     = "OU=FSX,OU=AWS,OU=ServersSecure,OU=!Common,DC=corp,DC=internal,DC=companyA,DC=com"
  description = "OU name"
}

variable "password" {
  type        = string
  default     = null
  description = "Password for Service Acct"
}

variable "storage_type" {
  type        = string
  default     = ""
  description = "Storage type"
}

variable "storage_capacity" {
  type        = string
  default     = ""
  description = "Storage Capacity"
}

variable "throughput_capacity" {
  type        = string
  default     = ""
  description = "Throrughput Capacity"
}

variable "username" {
  type        = string
  default     = "SVC_AWS_FSx"
  description = "Service Account username"
}

variable "fsx_subnet_count" {
  type        = number
  default     = 2
  description = "Number of subnet IDs to retrieve. Options: 1,2,3"
}

version.tf
terraform {
  required_version = ">= 0.13.0"
}
