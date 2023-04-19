
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_build_subnet_ids" {
  value = [aws_subnet.build_server_1.id, aws_subnet.build_server_2.id]
}

output "availability_zone_names" {
  value = data.aws_availability_zones.available.names
}

output "rt_ngw_a" {
  value = aws_route_table.rt_ngw_a.id
}

output "rt_ngw_b" {
  value = aws_route_table.rt_ngw_b.id
}

output "bastion_eip_allocid" {
  value = aws_eip.bastion.id
}

