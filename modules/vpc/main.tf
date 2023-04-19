
locals {
  # list of avaliable azs
  multi_az_deployment_count = var.multi_az_deployment ? 2 : 1
  public_subnets            = slice(var.public_subnets, 0, local.multi_az_deployment_count)
  private_subnets           = slice(var.private_subnets, 0, local.multi_az_deployment_count)
  create_vpc                = var.create_vpc && length(var.cidr) > 0 && length(local.public_subnets) > 0 && length(local.private_subnets) > 0
  create_private_subnets    = var.create_vpc && length(var.private_subnets) > 0 && var.nat_gateways > 0 && (var.nat_gateways <= length(var.public_subnets))
}

resource "aws_vpc" "main" {
  count                = local.create_vpc ? 1 : 0
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${var.app_name}-${var.stage_name}"
  }
}

# One public and one private subnet in 2 AZs

resource "aws_subnet" "public" {
  count                   = local.create_vpc ? length(slice(var.aws_availability_zones, 0, local.multi_az_deployment_count)) : 0
  vpc_id                  = element(aws_vpc.main.*.id, 0)
  cidr_block              = element(local.public_subnets, count.index)
  availability_zone       = element(var.aws_availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "public-subnet-${var.app_name}-${var.stage_name}-${var.aws_availability_zones[count.index]}-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
    Tier                                        = "Public"
  }
}

resource "aws_subnet" "private" {
  count             = local.create_private_subnets ? length(slice(var.aws_availability_zones, 0, local.multi_az_deployment_count)) : 0
  vpc_id            = element(aws_vpc.main.*.id, 0)
  cidr_block        = element(local.private_subnets, count.index)
  availability_zone = element(var.aws_availability_zones, count.index)

  tags = {
    Name                                        = "private-subnet-${var.app_name}-${var.stage_name}-${var.aws_availability_zones[count.index]}-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
    Tier                                        = "Private"
  }
}

# Routing Table for subnets
# public
resource "aws_route_table" "public" {
  count  = local.create_vpc ? 1 : 0
  vpc_id = one(aws_vpc.main[*]).id
}

resource "aws_route" "public" {
  count                  = local.create_vpc ? 1 : 0
  route_table_id         = one(aws_route_table.public[*]).id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = one(aws_internet_gateway.main[*]).id
}

resource "aws_route_table_association" "public" {
  count          = local.create_vpc ? length(local.public_subnets) : 0
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}

# private
resource "aws_route_table" "private" {
  count  = local.create_private_subnets ? length(local.private_subnets) : 0
  vpc_id = one(aws_vpc.main[*]).id
}

resource "aws_route" "private" {
  count                  = local.create_private_subnets ? length(local.private_subnets) : 0
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count          = local.create_private_subnets ? length(local.private_subnets) : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# IG for public subnet

resource "aws_internet_gateway" "main" {
  count  = local.create_vpc ? 1 : 0
  vpc_id = one(aws_vpc.main[*]).id

  tags = {
    Name = "igw-${var.app_name}-${var.stage_name}-${count.index + 1}"
  }
}

# NAT g/w for private subnets

resource "aws_nat_gateway" "main" {
  count         = local.create_private_subnets ? var.nat_gateways : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "natgw-${var.app_name}-${var.stage_name}-${count.index + 1}"
  }
}

resource "aws_eip" "nat" {
  count      = local.create_private_subnets ? var.nat_gateways : 0
  vpc        = true
  depends_on = [aws_internet_gateway.main]
  tags = {
    Name = "eip-${var.app_name}-${var.stage_name}-${count.index + 1}"
  }
}