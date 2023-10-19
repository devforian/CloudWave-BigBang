output "bb_tmp_id" {
  description = "The ID of the launch template."
  value       = aws_launch_template.bb_tmp.id
}

output "bb_tmp_name" {
  description = "The name of the launch template."
  value       = aws_launch_template.bb_tmp.name
}

output "bb_tmp_image_id" {
  description = "The AMI ID of the launch template."
  value       = aws_launch_template.bb_tmp.image_id
}

output "bb_tmp_instance_type" {
  description = "The instance type specified in the launch template."
  value       = aws_launch_template.bb_tmp.instance_type
}




