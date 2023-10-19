resource "aws_iam_policy" "infra_policy" {
  count = length(var.infra_policy_files)
  name  = "bb_policy_${count.index}"
  policy = file("${path.module}/../${var.infra_policy_files[count.index]}")
}