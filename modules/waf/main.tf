resource "aws_wafv2_web_acl" "bb_waf" {
  name  = "bb_${var.infra_env}_waf"
  scope = "CLOUDFRONT"

  default_action { 
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "WebACLMetrics"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action { 
        count {} 
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"  # 규칙 세트의 이름
        vendor_name = "AWS"                           # 규칙 세트의 공급자 (AWS)
      }
    }
  }
}
