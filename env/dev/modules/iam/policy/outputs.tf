output "policy_arns" {
  value = [for policy in aws_iam_policy.infra_policy: policy.arn]
}