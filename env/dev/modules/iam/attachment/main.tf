resource "aws_iam_group_policy_attachment" "bb_attachment" {
  count = length(var.group_names)

  group      = var.group_names[count.index]
  policy_arn = var.policy_arns[count.index]
}