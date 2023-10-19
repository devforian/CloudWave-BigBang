output "bb_web_alb_arn" {
  description = "The ARN of the web application load balancer."
  value       = aws_lb.bb_web_alb.arn
}

output "bb_web_alb_dns_name" {
  description = "The DNS name of the web application load balancer."
  value       = aws_lb.bb_web_alb.dns_name
}

output "bb_web_alb_zone_id" {
  description = "The canonical hosted zone ID of the web application load balancer (to be used in a Route 53 Alias record)."
  value       = aws_lb.bb_web_alb.zone_id
}

output "bb_web_alb_tg_arn" {
  description = "The ARN of the target group for the web application load balancer."
  value       = aws_lb_target_group.bb_web_alb_tg.arn
}

output "bb_web_alb_tg_name" {
  description = "The name of the target group for the web application load balancer."
  value       = aws_lb_target_group.bb_web_alb_tg.name
}

output "bb_web_alb_ln_01_arn" {
  description = "The ARN of the listener for the web application load balancer."
  value       = aws_lb_listener.bb_web_alb_ln_01.arn
}

output "bb_web_alb_ln_02_arn" {
  description = "The ARN of the listener for the web application load balancer."
  value       = aws_lb_listener.bb_web_alb_ln_02.arn
}

output "bb_web_alb_ln_01_default_action" {
  description = "The default action type (e.g., `forward`) for the listener."
  value       = aws_lb_listener.bb_web_alb_ln_01.default_action[0].type
}

output "bb_web_alb_ln_02_default_action" {
  description = "The default action type (e.g., `forward`) for the listener."
  value       = aws_lb_listener.bb_web_alb_ln_02.default_action[0].type
}

output "bb_was_alb_arn" {
  description = "The ARN of the was application load balancer."
  value       = aws_lb.bb_was_alb.arn
}

output "bb_was_alb_dns_name" {
  description = "The DNS name of the was application load balancer."
  value       = aws_lb.bb_was_alb.dns_name
}

output "bb_was_alb_zone_id" {
  description = "The canonical hosted zone ID of the was application load balancer (to be used in a Route 53 Alias record)."
  value       = aws_lb.bb_was_alb.zone_id
}

output "bb_was_alb_tg_arn" {
  description = "The ARN of the target group for the was application load balancer."
  value       = aws_lb_target_group.bb_was_alb_tg.arn
}

output "bb_was_alb_tg_name" {
  description = "The name of the target group for the was application load balancer."
  value       = aws_lb_target_group.bb_was_alb_tg.name
}

output "bb_was_alb_ln_01_arn" {
  description = "The ARN of the listener for the was application load balancer."
  value       = aws_lb_listener.bb_was_alb_ln_01.arn
}

output "bb_was_alb_ln_02_arn" {
  description = "The ARN of the listener for the was application load balancer."
  value       = aws_lb_listener.bb_was_alb_ln_02.arn
}

output "bb_was_alb_ln_01_default_action" {
  description = "The default action type (e.g., `forward`) for the listener."
  value       = aws_lb_listener.bb_was_alb_ln_01.default_action[0].type
}

output "bb_was_alb_ln_02_default_action" {
  description = "The default action type (e.g., `forward`) for the listener."
  value       = aws_lb_listener.bb_was_alb_ln_02.default_action[0].type
}