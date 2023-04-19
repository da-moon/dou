# terraform-aws-vpc-ssm

## Summary
Amazon Virtual Private Cloud (Amazon VPC) enables you to launch AWS resources into a virtual network that you've defined. This virtual network closely resembles a traditional network that you'd operate in your own data center, with the benefits of using the scalable infrastructure of AWS.

## Build status
[![CircleCI](https://circleci.com/gh/DigitalOnUs/terraform-aws-vpc-ssm/tree/main.svg?style=svg&circle-token=548549ed91f3718a4ba7b31af17614e7bbb6941c)](https://circleci.com/gh/DigitalOnUs/terraform-aws-vpc-ssm/tree/main)

## Getting Started

**Example**

```terraform
module "module" {
  source = "github.com/DigitalOnUs/terraform-aws-vpc-ssm?ref=0.0.1"
  
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  enable_dns_support   = false
  enable_dns_hostnames = false

  enable_classiclink             = false
  enable_classiclink_dns_support = false

  assign_generated_ipv6_cidr_block = true

  tags = {
    Name        = "vpc-ssm"
    Application = "terraform-aws-vpc-ssm"
  }
}
```

**Outputs**
| Name                      | Description                                                     |
|---------------------------|-----------------------------------------------------------------|
| vpc_arn                   | The group's ID.                                                 |
| id                        | The group's name.                                               |
| cidr_block                | The CIDR block of the VPC                                       |
| owner_id                  | The ID of the AWS account that owns the VPC.                    |
| ipv6_cidr_block           | he IPv6 CIDR block.                                             |
| main_route_table_id       | The ID of the main route table associated with this VPC. Note that you can change a VPC's main route table by using an aws_main_route_table_association |
| default_security_group_id | The ID of the security group created by default on VPC creation |
| default_network_acl_id    | The ID of the network ACL created by default on VPC creation    |
| default_route_table_id    | LThe ID of the route table created by default on VPC creation   |
| ipv6_association_id       | The association ID for the IPv6 CIDR block.                     |
