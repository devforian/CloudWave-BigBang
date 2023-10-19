output "bb_web_alb_sg_id" {
  description = "Security Group ID for bb_web_alb_sg"
  value       = aws_security_group.bb_web_alb_sg.id
}

output "bb_pub_a_bastion_sg_id" {
  description = "Security Group ID for bb_pub_a_bastion_sg"
  value       = aws_security_group.bb_pub_a_bastion_sg.id
}

output "bb_web_asg_sg_id" {
  description = "Security Group ID for bb_web_asg_sg"
  value       = aws_security_group.bb_web_asg_sg.id
}

output "bb_was_alb_sg_id" {
  description = "Security Group ID for bb_was_alb_sg"
  value       = aws_security_group.bb_was_alb_sg.id
}

output "bb_was_asg_sg_id" {
  description = "Security Group ID for bb_was_asg_sg"
  value       = aws_security_group.bb_was_asg_sg.id
}

output "bb_rds_sg_id" {
  description = "Security Group ID for bb_rds_sg"
  value       = aws_security_group.bb_rds_sg.id
}

# output "bb_lambda_sg_id" {
#   description = "The ID of the bb_lambda security group"
#   value       = aws_security_group.bb_labmda_sg.id
# }