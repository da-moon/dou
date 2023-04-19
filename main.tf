resource "aws_route_table" "route_table" {
  vpc_id           = var.vpc_id
  propagating_vgws = var.propagating_virtual_gateways

  dynamic "route" {
    for_each = var.route_objects
    content {
      cidr_block                 = lookup(route.value, "cidr_block", null)
      ipv6_cidr_block            = lookup(route.value, "ipv6_cidr_block", null)
      destination_prefix_list_id = lookup(route.value, "destination_prefix_list_id", null)

      carrier_gateway_id        = lookup(route.value, "carrier_gateway_id", null)
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      local_gateway_id          = lookup(route.value, "local_gateway_id", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }

  tags = var.tags
}

resource "aws_route_table_association" "assoc_gateway" {
  count = length(var.assoc_gateway)

  route_table_id = aws_route_table.route_table.id
  gateway_id     = element(var.assoc_gateway, count.index)
}

resource "aws_route_table_association" "assoc_subnet" {
  count = length(var.assoc_subnet)

  route_table_id = aws_route_table.route_table.id
  subnet_id      = element(var.assoc_subnet, count.index)
}