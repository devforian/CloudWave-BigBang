output "public_subnets_ids" {
  description = "List of IDs of the public subnets"
  value       = aws_subnet.public_subnets.*.id
}

output "private_subnets_ids" {
  description = "List of IDs of the private subnets"
  value       = aws_subnet.private_subnets.*.id
}

output "private_subnets_names" {
  value = [for s in aws_subnet.private_subnets : s.tags["Name"]]
  description = "Names of the private subnets"
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.bb_igw.id
}

output "nat_gateway_a_id" {
  description = "ID of the NAT Gateway for availability zone a"
  value       = aws_nat_gateway.bb_nat_a.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.bb_rtb_pub.id
}

output "private_route_table_a_ids" {
  description = "List of IDs of the private route tables for availability zone a"
  value       = aws_route_table.private_a.*.id
}

output "public_route_table_associations" {
  description = "List of IDs of the route table associations for public subnets"
  value       = aws_route_table_association.public.*.id
}

output "private_route_table_association_a_01" {
  description = "ID of the route table association for private subnet in availability zone a"
  value       = aws_route_table_association.private_a_01.id
}