# terraform-aws-security-group-ssm

## Summary
A security group acts as a virtual firewall for your instance to control inbound and outbound traffic. When you launch an instance in a VPC, you can assign up to five security groups to the instance. Security groups act at the instance level, not the subnet level. Therefore, each instance in a subnet in your VPC can be assigned to a different set of security groups.

## Build status
[![CircleCI](https://circleci.com/gh/DigitalOnUs/terraform-aws-security-group-ssm/tree/main.svg?style=svg&circle-token=8c113e1ca6dcd9f98a97122de43f432f5b14a5ae)](https://circleci.com/gh/DigitalOnUs/terraform-aws-security-group-ssm/tree/main)

## Getting Started

**Example**

```terraform
module "module" {
  source = "github.com/DigitalOnUs/terraform-aws-security-group-ssm?ref=0.0.1"
  
  vpc_id     = aws_vpc.vpc.id
  description = "Allow TLS inbound traffic"

  ingress_rules = [{
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.vpc.cidr_block]
  },
  {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.vpc.cidr_block]
  }]

  egress_rules =  [{
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }]

  tags = {
    Name        = "security-group-ssm"
    Application = "terraform-aws-security-group-ssm"
  }
}
```

**Outputs**
| Name     | Description                 |
|----------|-----------------------------|
| arn      | ARN of the security group.  |
| id       | ID of the security group.   |
| name     | Name of the security group. |
| owner_id | Owner ID.                   |
