output "bb_acm_cert_arn" {
  description = "The ARN of the ACM certificate."
  value       = aws_acm_certificate.bb_acm_cert.arn
}

output "bb_r53_zone_id" {
  description = "The ID of the Route53 zone."
  value       = data.aws_route53_zone.bb_r53_zone.zone_id
}

output "bb_acm_cert_validation_record_fqdns" {
  description = "The FQDNs of the ACM certificate validation records."
  value       = aws_acm_certificate_validation.bb_acm_cert_validation.validation_record_fqdns
}

output "bb_web_alb_record_name" {
  description = "The name of the ALB Route53 record."
  value       = length(aws_route53_record.bb_web_alb_record) > 0 ? aws_route53_record.bb_web_alb_record[0].fqdn : null
}

output "bb_web_alb_record_alias" {
  description = "The alias details of the ALB Route53 record."
  value = length(aws_route53_record.bb_web_alb_record) > 0 ? {
    name                   = aws_route53_record.bb_web_alb_record[0].alias[0].name
    zone_id                = aws_route53_record.bb_web_alb_record[0].alias[0].zone_id
    evaluate_target_health = aws_route53_record.bb_web_alb_record[0].alias[0].evaluate_target_health
  } : null
}