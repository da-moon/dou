data "aws_subnets" "existing" {
  filter {
    name   = "vpc-id"
    values = [jsondecode(data.aws_s3_object.core_outputs.body).vpc_id]
  }
}

data "aws_subnet" "existing" {
  for_each = toset(data.aws_subnets.existing.ids)
  id       = each.value
}

locals {
  name_prefix = jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix != "" ? "${jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix}-tc-${var.env_name}" : "tc-${var.env_name}"
  # other_subnets is the subnet list of all subnets in the vpc not matching this environment name
  other_subnets = [for s in data.aws_subnet.existing : s if length(regexall(var.env_name, s.tags["Name"])) == 0]
  # own_subnets are the existing subnets for this environment
  own_subnets = [for s in data.aws_subnet.existing : s if length(regexall(var.env_name, s.tags["Name"])) > 0]
  # highest_cidr_other is the highest cidr value of all the other subnets
  highest_cidr_other = reverse(sort([for s in local.other_subnets : s.cidr_block]))[0]
  # own_cidrs are the existing cidr blocks for this environment, as a map of key = padded cidr and value = real cidr
  own_cidrs = { for s in local.own_subnets : join(".", [for octet in split(".", s.cidr_block) : format("%03s", octet)]) => s.cidr_block }
  # Calculate cidr blocks
  subnet_1_cidr = length(local.own_cidrs) > 0 ? values(local.own_cidrs)[0] : "10.0.${sum([split(".", local.highest_cidr_other)[2], 9])}.0/24"
  subnet_2_cidr = length(local.own_cidrs) > 0 ? values(local.own_cidrs)[1] : "10.0.${sum([split(".", local.highest_cidr_other)[2], 10])}.0/24"
}

resource "aws_subnet" "env_subnet_1" {
  vpc_id            = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id
  cidr_block        = var.env_cidr_private_subnets == null ? local.subnet_1_cidr : "${var.env_cidr_private_subnets[0]}"
  availability_zone = jsondecode(data.aws_s3_object.core_outputs.body).availability_zone_names[0]

  tags = {
    Name = "${local.name_prefix}-private-subnet-1"
  }
}

resource "aws_subnet" "env_subnet_2" {
  vpc_id            = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id
  cidr_block        = var.env_cidr_private_subnets == null ? local.subnet_2_cidr : "${var.env_cidr_private_subnets[1]}"
  availability_zone = jsondecode(data.aws_s3_object.core_outputs.body).availability_zone_names[1]

  tags = {
    Name = "${local.name_prefix}-private-subnet-2"
  }
}

resource "aws_route_table_association" "env_1" {
  subnet_id      = aws_subnet.env_subnet_1.id
  route_table_id = jsondecode(data.aws_s3_object.core_outputs.body).rt_ngw_a
}

resource "aws_route_table_association" "env_2" {
  subnet_id      = aws_subnet.env_subnet_2.id
  route_table_id = jsondecode(data.aws_s3_object.core_outputs.body).rt_ngw_b
}
