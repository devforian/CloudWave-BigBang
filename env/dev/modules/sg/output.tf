output "bastion_sg_id" {
  value = aws_security_group.bb_bastion_sg.id
}

output "web_was_sg_id" {
  description = "The ID of the bb_web_was_sg security group"
  value       = aws_security_group.bb_web_was_sg.id
}

output "rds_sg_id" {
  description = "The ID of the bb_rds_sg security group"
  value       = aws_security_group.bb_rds_sg.id
}

output "web_was_sg_name" {
  description = "The name of the bb_web_was_sg security group"
  value       = aws_security_group.bb_web_was_sg.name
}

output "rds_sg_name" {
  description = "The name of the bb_rds_sg security group"
  value       = aws_security_group.bb_rds_sg.name
}