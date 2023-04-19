## ====================
variable "aws_vpc_cidr_block" {
  description = "CIDR block for the AWS VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_vault_sg_name" {
  description = "AWS Security Group name that will be set on the security group"
  type        = string
  default     = "hcp-vault-sg"
}

variable "aws_vault_sg_desc" {
  description = "Description for the AWS Security Group that will be created to allow access to Vault"
  type        = string
  default     = "Security Group that allows access to HCP Vault"
}

variable "aws_tag_ttl" {
  description = "TTL of the resources that will be provisioned for this demo. Specified in hours."
  type        = number
  default     = 24
}

variable "aws_tag_service" {
  description = "Name of the service that this environment is supporting"
  type        = string
  default     = "vault"
}

variable "aws_tag_environment" {
  description = "Tag that will be applied to all AWS resources"
  type        = string
  default     = "hcp"
}

variable "aws_tag_owner" {
  description = "Your email - This tag that will be appled to all AWS resources."
  type        = string
}

variable "aws_tgw_bgp_asn" {
  description = "BGP ASN that will be configured on the AWS Transit Gateway. Defaults to 64512"
  default     = 64512
  type        = number
}

variable "aws_hcp_tgw_ram_name" {
  description = "Name of the AWS RAM that will be created to allow resource sharing between accounts"
  type        = string
  default     = "hcp-ram"
}

variable "hvn_cidr_block" {
  description = "CIDR block for the HashiCorp Virtual Network VPC in HCP"
  type        = string
  default     = "172.25.16.0/20"
}

######################## New Variables

variable "aws_tfc_agent_subnet" {
  description = "CIDR block for TFC Agent workloads. Should be allocated from the VPC subnet range."
  type        = string
  default     = "10.0.2.0/24"
}

variable "aws_nat_subnet" {
  description = "CIDR block for the AWS NAT Gateway. Should be allocated from the VPC subnet range."
  type        = string
  default     = "10.0.3.0/24"
}

variable "aws_tfc_sg_name" {
  description = "Name of the Security Group that will be created for TFC Agent workloads."
  type        = string
  default     = "hcp-tfc-agent-sg"
}

variable "aws_tfc_sg_desc" {
  description = "Description for the Security Group that will be created for TFC Agent workloads."
  type        = string
  default     = "Security Group for the TFCB Agent workloads"
}


## EC2
variable "aws_hcp_tfc_ec2_name" {
  description = "Name of the EC2 instance that will run the TFC agent"
  type        = string
  default     = "hcp-vault-tfc-agent"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance that will be deployed. Defaults to t2.micro"
  type        = string
  default     = "t2.medium"
}

variable "tfc_agent_token" {
  description = "Token that will be used inside of the EC2 instance"
  type        = string
}

variable "tfc_agent_name" {
  description = "Name that will be applied to the TFC agent inside of the EC2 instace"
  type        = string
  default     = "aws-ec2-tfcb-agent"
}


variable "ami" {
  description = "Variable used for looking up the AMI for images within AWS based on name and the owner ID"
  type        = map(string)
  default = {
    name   = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    owners = "099720109477"
  }
}
