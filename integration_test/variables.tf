variable "name" {
  description = "application name"
  type        = string
}

variable "account_name" {
  type        = string
  description = "Account Alias to build in"
}

variable "mandatory_tags" {
  description = "Map with the mandatory tags"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "App Environment (Dev/Test/QA/Prod/etc)"
  type        = string
}

variable "capacity_rebalance" {
  description = "Indicates whether capacity rebalance is enabled. Otherwise, capacity rebalance is disabled "
  type        = string
  default     = "false"
}

variable "additional_tags" {
  description = "Map of Key-Value-Pairs describing any additional Tags to place on Resources"
  type        = map(string)
  default     = {}
}

variable "ec2_sg_name_search" {
  description = "Regex expression to search for SG names on EC2 and retrieve its IDs"
  type        = string
  default     = ""
}

variable "alb_sg_name_search" {
  description = "Regex expression to search for SG names on ALB and retrieve its IDs"
  type        = string
  default     = ""
}

variable "ebs_kms_key_alias" {
  type        = string
  default     = ""
  description = "KMS key alias name. alias/ prefix is not needed."
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

variable "max_size" {
  description = "The maximum size of the auto scale group"
  type        = string
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

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  type        = string
}

variable "https_listeners" {
  description = "A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-2016-08), target_group_index (defaults to https_listeners[count.index])"
  type        = any
  default     = []
}

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port"
  type        = any
  default     = []
}

variable "vault_role_name" {
  description = "Automation Role name"
  type        = string
  default     = "example-app-automation-role"
}

variable "block_device_mappings" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(map(string))
  default     = []
}

variable "os" {
  description = "OS options: windows, linux"
  type        = string
  default     = "linux"
}

variable "ami_name_tag" {
  description = "AMI name tag to override default AMI tag given after published AMI."
  type        = string
  default     = ""
}
