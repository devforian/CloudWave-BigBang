data "aws_region" "current" {}

locals {
  alb_record_name_prefix = data.aws_region.current.name == "ap-southeast-1" ? "sp" : "kr"
}

resource "aws_backup_vault" "bb_vault" {
  #name        = "bb_${local.name_prefix}_${var.infra_env}_backup_vault"
  name        = "bb-${local.alb_record_name_prefix}-${var.infra_env}-backup_vault"
  kms_key_arn = aws_kms_key.bb_kms.arn
}

# KMS 키 생성 (이미 생성된 경우 제외)
resource "aws_kms_key" "bb_kms" {
  #description             = "bb_${local.name_prefix}_${var.infra_env}_KMS_Key"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}
