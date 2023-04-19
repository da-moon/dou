# Create Internet Gateway Config
resource "aws_internet_gateway" "caas" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Project     = var.project_name
    Environment = var.run_env
  }
}

# Create Default Route
resource "aws_default_route_table" "caas" {
  default_route_table_id = module.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.caas.id
  }
  tags = {
    Project     = var.project_name
    Environment = var.run_env
  }
}
