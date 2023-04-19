# terraform-aws-newtork-spw

## Summary
This SPW create a VPC and multiple subnets and security groups 

## Build status
[![CircleCI](https://circleci.com/gh/DigitalOnUs/terraform-aws-network-spw/tree/main.svg?style=svg&circle-token=6072d1bc6726213ad832df2082aae450c3052f5c)](https://circleci.com/gh/DigitalOnUs/terraform-aws-network-spw/tree/main)

## Getting Started

**Example**

```terraform
module "module" {
  source = "github.com/DigitalOnUs/terraform-aws-network-spw?ref=0.0.1"
  
  cidr_block = "172.16.0.0/16"

  #### SUBNET
  subnet_config = [
    {
      cidr_block        = "172.16.10.0/24"
      availability_zone = "eu-central-1a"
    },
    {
      cidr_block = "172.16.30.0/24"
    }
  ]

  #### SECURITY GROUP
  securitygroup_config = [{
    securitygroup_name = "sgwithspw"
    description        = "Allow TLS inbound traffic"

    ingress_rules = [{
      description = "TLS from VPC"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      },
      {
        description = "TLS from VPC"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
    }]

    egress_rules = [{
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }]
  }]

  tags = {
    Application = "terratest-network-spw"
    Environment = "NonProd"
  }
}
```

**Example with VPC and Subnets**

```terraform
module "module" {
  source = "github.com/DigitalOnUs/terraform-aws-network-spw?ref=0.0.1"
  
  cidr_block = "172.16.0.0/16"

  #### SUBNET
  subnet_config = [
    {
      cidr_block        = "172.16.10.0/24"
      availability_zone = "eu-central-1a"
    },
    {
      cidr_block = "172.16.30.0/24"
    }
  ]

  tags = {
    Application = "terratest-network-spw"
    Environment = "NonProd"
  }
}
```

**Outputs**
| Name                       | Description                |
|----------------------------|----------------------------|
| vpc_arn                    | Amazon Resource Name (ARN) of VPC |
| vpc_id                     | The ID of the VPC |
| cidr_block                 | The CIDR block of the VPC |
| owner_id                   | owner_id |
| ipv6_cidr_block            | The IPv6 CIDR block |
| main_route_table_id        | The ID of the main route table associated with this VPC. Note that you can change a VPC's main route table by using an aws_main_route_table_association |
| default_security_group_id  | The ID of the security group created by default on VPC creation |
| default_route_table_id     | The ID of the route table created by default on VPC creation |
| ipv6_association_id        | The association ID for the IPv6 CIDR block |
| subnet_id                  | The IDs of the subnets |
| subnet_arn                 | The ARN of the subnets |
| subnet_ipv6_association_id | The association IDs for the IPv6 CIDR block. |
| sg_id                      | IDs of the security group |
| sg_name                    | Security Groups Name |
| sg_arn                     | ARN of the security groups. |