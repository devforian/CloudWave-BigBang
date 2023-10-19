output "bb_bastion_public_ip" {
  value = aws_instance.bb_bastion.public_ip
  description = "The public IP address of the bb_pub_a_bastion instance."
}

output "bb_bastion_instance_id" {
  value = aws_instance.bb_bastion.id
  description = "The instance ID of the bb_pub_a_bastion instance."
}