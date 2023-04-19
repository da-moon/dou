# terraform-aws-subnet-ssm

## Summary
A subnet is a range of IP addresses in your VPC. You can launch AWS resources, such as EC2 instances, into a specific subnet. When you create a subnet, you specify the IPv4 CIDR block for the subnet, which is a subset of the VPC CIDR block. Each subnet must reside entirely within one Availability Zone and cannot span zones.

## Build status


## Getting Started

**Basic Example**

```terraform
module "module" {
  source = "github.com/DigitalOnUs/terraform-aws-subnet-ssm?ref=0.0.1" 
  
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name        = "subnet-ssm"
    Application = "terraform-aws-subnet-ssm"
  }
}
```

**Allow public IPs in the subnet**

```terraform
module "module" {
  source = "github.com/DigitalOnUs/terraform-aws-subnet-ssm?ref=0.0.1" 
  
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  allow_public_ip                 = true
  assign_ipv6_address_on_creation = false

  tags = {
    Name        = "subnet-ssm"
    Application = "terraform-aws-subnet-ssm"
  }
}
```

**Outputs**
| Name                | Description                                     |
|---------------------|-------------------------------------------------|
| arn                 | The ID of the subnet.                           |
| id                  | The ARN of the subnet.                          |
| ipv6_association_id | The association ID for the IPv6 CIDR block.     |
| owner_id            | The ID of the AWS account that owns the subnet. |
