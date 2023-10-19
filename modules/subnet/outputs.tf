output "public_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.public_subnets.*.id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private_subnets.*.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.bb_igw.id
}

######### eip와 nat는 리스트에 담으면 output에 출력되지 않음 #########
output "eip_nat_a" {
  description = "Elastic IP associated with NAT gateway A"
  value       = aws_eip.bb_nat_a.id
}

output "eip_nat_c" {
  description = "Elastic IP associated with NAT gateway C"
  value       = aws_eip.bb_nat_c.id
}

output "nat_gateway_a_id" {
  description = "The ID of NAT Gateway A"
  value       = aws_nat_gateway.bb_nat_a.id
}

output "nat_gateway_c_id" {
  description = "The ID of NAT Gateway C"
  value       = aws_nat_gateway.bb_nat_c.id
}