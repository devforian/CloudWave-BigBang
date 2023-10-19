output "bb_vpc_id" {
    value = module.bb_vpc.vpc_id
}

output "bb_web_sg" {
    value = module.bb_sg.bb_web_asg_sg_id
}

output "bb_was_sg" {
    value = module.bb_sg.bb_was_asg_sg_id
}

output "bb_pub_subnet_ids" {
    value = module.bb_subnet.public_subnet_ids
}

output "bb_pri_subnets_ids" {
    value = module.bb_subnet.private_subnet_ids
}

output "bb_acm_cert_arn" {
    value = module.bb_acm.bb_acm_cert_arn
}

output "bb_was_alb_sg_id" {
    value = module.bb_sg.bb_web_asg_sg_id
}