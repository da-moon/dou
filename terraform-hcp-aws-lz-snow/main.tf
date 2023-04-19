data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.aws_vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  #checkov:skip=CKV2_AWS_11: Not using CloudWatch can be added later
  tags = {
    Name = "${var.aws_tag_environment}-${var.aws_tag_service}-vpc"
  }
}

resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.aws_tfc_agent_subnet
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.aws_tag_environment}-${var.aws_tag_service}-agent-subnet"
  }
}

resource "aws_subnet" "nat_gateway" {
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = var.aws_nat_subnet
  vpc_id            = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.aws_tag_environment}-${var.aws_tag_service}-natgw-subnet"
  }
}

// creates an internet gateway and attaches it to the vpc
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.aws_tag_environment}-${var.aws_tag_service}-igw"
  }
}

resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_eip" "nat_gateway" {
  vpc = true

  tags = {
    Name = "${var.aws_tag_environment}-${var.aws_tag_service}-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.nat_gateway.id
  tags = {
    Name = "${var.aws_tag_environment}-${var.aws_tag_service}-natgw"
  }
}

resource "aws_route_table" "instance" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "${var.aws_tag_environment}-${var.aws_tag_service}-nat-rt"
  }
}

resource "aws_route_table_association" "instance" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.instance.id
}


resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block         = var.hvn_cidr_block
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }

  tags = {
    Name = "${var.aws_tag_environment}-${var.aws_tag_service}-rt"
  }
}

// associates the route table with the vpc
resource "aws_main_route_table_association" "main_vpc" {
  vpc_id         = aws_vpc.main_vpc.id
  route_table_id = aws_route_table.main_rt.id
}

// creates a transit gateway (tgw)
resource "aws_ec2_transit_gateway" "tgw" {
  amazon_side_asn                 = var.aws_tgw_bgp_asn
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  vpn_ecmp_support                = "enable"
  dns_support                     = "enable"
  tags = {
    Name = "${var.aws_tag_environment}-${var.aws_tag_service}-tgw"
  }
}

// attaches the main vpc with the tgw
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw" {
  subnet_ids         = [aws_subnet.main_subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.aws_tag_environment}-${var.aws_tag_service}-tgw-attachment"
  }
}

// creates an resource access manager for sharing the tgw across accounts
resource "aws_ram_resource_share" "ram" {
  name                      = var.aws_hcp_tgw_ram_name
  allow_external_principals = true
}

// associates the resource access manager arn with the tgw arn
resource "aws_ram_resource_association" "ram_asc" {
  resource_share_arn = aws_ram_resource_share.ram.arn
  resource_arn       = aws_ec2_transit_gateway.tgw.arn
}





// creates a route table that allows access to the HCP  cluster from the tfc agent subnet and configures internet egress access


resource "aws_security_group" "tfc_isolated" {
  name        = var.aws_tfc_sg_name
  vpc_id      = aws_vpc.main_vpc.id
  description = var.aws_tfc_sg_desc
  #checkov:skip=CKV2_AWS_5: Creating Security Groups in a different workspace to be consumed later
  egress {
    description = "Allows egress access to the internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sgr
  }
}

## Merging 2 workspaces
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.ami.name]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = [var.ami.owners] # Canonicals
}

resource "aws_instance" "ec2_tfc_agent" {

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.main_subnet.id
  vpc_security_group_ids      = [aws_security_group.tfc_isolated.id]
  associate_public_ip_address = false
  #checkov:skip=CKV_AWS_135: Not using EBS Optimized AMI
  ebs_optimized = false
  monitoring    = true
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  root_block_device {
    encrypted = true
  }
  user_data_base64 = base64encode(local.tfc_user_data)
  tags = {
    Name = var.aws_hcp_tfc_ec2_name
  }
  lifecycle {
    ignore_changes = [ami]
  }
}

locals {
  tfc_user_data = templatefile("${path.module}/tfc.tpl.tmpl", {
    tfc_agent_token = var.tfc_agent_token
    tfc_agent_name  = var.tfc_agent_name
  })
}
