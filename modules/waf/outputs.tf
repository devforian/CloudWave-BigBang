output "bb_waf_arn" {
  description = "The ARN of the WAFv2 Web ACL."
  value       = aws_wafv2_web_acl.bb_waf.arn
}

output "bb_waf_id" {
  description = "The ID of the WAFv2 Web ACL."
  value       = aws_wafv2_web_acl.bb_waf.id
}

output "bb_waf_capacity" {
  description = "The capacity of the WAFv2 Web ACL."
  value       = aws_wafv2_web_acl.bb_waf.capacity
}

output "bb_waf_lock_token" {
  description = "The lock token of the WAFv2 Web ACL."
  value       = aws_wafv2_web_acl.bb_waf.lock_token
}
