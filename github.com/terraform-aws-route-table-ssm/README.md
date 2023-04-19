# terraform-aws-route-table-ssm

## Summary
A route table contains a set of rules, called routes, that are used to determine where network traffic from your subnet or gateway is directed.
Multiples subnets and internet gateway or a virtual private gateway can be associated with a route table.

## Build status
[![CircleCI](https://circleci.com/gh/DigitalOnUs/terraform-aws-route-table-ssm/tree/main.svg?style=svg&circle-token=d3915fad41884c7ddafa0b415923d69ff1a677f9)](https://circleci.com/gh/DigitalOnUs/terraform-aws-route-table-ssm/tree/main)

## Getting Started

**Example**

```terraform
module "module" {
  source = "github.com/DigitalOnUs/terraform-aws-route-table-ssm?ref=0.0.1"
  
  vpc_id     = aws_vpc.vpc.id

  route_objects = [{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    },
  ]

  tags = {
    Name        = "route-table-ssm"
    Application = "terraform-aws-route-table-ssm"
  }
}
```

**Subnet association**

```terraform
module "module" {
  source = "github.com/DigitalOnUs/terraform-aws-route-table-ssm?ref=0.0.1"
  
  vpc_id = aws_vpc.vpc.id
  route_objects = [{
      ipv6_cidr_block        = "::/0"
      egress_only_gateway_id = aws_egress_only_internet_gateway.egress_igw.id
    }
  ]

  assoc_subnet = [aws_subnet.subnet.id]

  tags = {
    Name        = "route-table-ssm"
    Application = "terraform-aws-route-table-ssm"
  }
}
```

**Outputs**
| Name                   | Description                            |
|------------------------|----------------------------------------|
| arn                    | ARN of the routing table.              |
| id                     | ID of the routing table.               |
| owner_id               | Owner ID.                              |
| association_id_gateway | The ID of the association of gateways. |
| association_id_subnet  | The ID of the association of subnets.  |