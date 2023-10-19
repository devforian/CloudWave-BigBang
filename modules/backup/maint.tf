# locals {
#   name_prefix = data.aws_region.current.name == "us-east-1" ? "us" : "kr"
# }

resource "aws_backup_vault" "bb_vault" {
  #name        = "bb_${local.name_prefix}_${var.infra_env}_backup_vault"
  name        = "bb_${var.infra_env}_backup_vault"
  kms_key_arn = aws_kms_key.bb_kms.arn
}

# KMS 키 생성 (이미 생성된 경우 제외)
resource "aws_kms_key" "bb_kms" {
  #description             = "bb_${local.name_prefix}_${var.infra_env}_KMS_Key"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

resource "aws_backup_plan" "bb_backup_plan" {
  name = "bb-${var.infra_env}-backup-plan"

  rule {
    rule_name         = "bb-${var.infra_env}-backup-plan-rule"
    target_vault_name = aws_backup_vault.bb_vault.name
    schedule          = "cron(0 2 ? * * *)"

    lifecycle {
      delete_after = 14
    }
    copy_action {
      destination_vault_arn = var.other_vault_arn
    }
  }
}

resource "aws_backup_selection" "bb_backup_selection" {
  iam_role_arn = aws_iam_role.bb_backup_iam_role.arn
  name         = "bb-${var.infra_env}-backup-selection"
  plan_id      = aws_backup_plan.bb_backup_plan.id
  resources    = ["*"]
}

resource "aws_iam_role" "bb_backup_iam_role" {
  name = "bb-${var.infra_env}-backup-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "bb_backup_policy" {
  name        = "bb-${var.infra_env}-backup-policy"
  path        = "/"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "FullAccessToAWSBackup",
            "Effect": "Allow",
            "Action": "backup:*",
            "Resource": "*"
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "backup_policy_attachment" {
          role = aws_iam_role.bb_backup_iam_role.name
          policy_arn = aws_iam_policy.bb_backup_policy.arn
}
