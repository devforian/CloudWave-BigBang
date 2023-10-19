#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation.html
data "aws_region" "current" {}

locals {
  alb_record_name_prefix = data.aws_region.current.name == "us-east-1" ? "us" : "kr"
}

resource "aws_acm_certificate" "bb_acm_cert" {
  domain_name       = "*.${local.alb_record_name_prefix}.${var.sub_domain}.${var.domain_name}"  # 등록할 도메인 입력
  validation_method = var.validation_method

  tags = {
    Name = "bb-${var.infra_env}-acm-cert"
  }
}

data "aws_route53_zone" "bb_r53_zone" {
  name         = var.domain_name
  private_zone = var.private_zone
}

resource "aws_route53_record" "bb_acm_cert_validation" {
  for_each = {
    for record in aws_acm_certificate.bb_acm_cert.domain_validation_options : record.domain_name => {
      name   = record.resource_record_name
      type   = record.resource_record_type
      record = record.resource_record_value
    }
  }
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = var.ttl
  zone_id = data.aws_route53_zone.bb_r53_zone.zone_id  # Route53의 Hosted Zone ID 입력
}

resource "aws_acm_certificate_validation" "bb_acm_cert_validation" {
  certificate_arn = aws_acm_certificate.bb_acm_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.bb_acm_cert_validation : record.fqdn]
}

resource "aws_route53_record" "bb_web_alb_record" {
  count = var.create_record ? 1 : 0
  name    = "www.${local.alb_record_name_prefix}.${var.sub_domain}.${var.domain_name}" # 등록할 도메인명
  type    = var.record_type
  zone_id = data.aws_route53_zone.bb_r53_zone.zone_id     # Route 53 Hosted Zone ID
  alias {
    name                   = var.web_alb_dns_name
    zone_id                = var.web_alb_zone_id
    evaluate_target_health = true
  }
}