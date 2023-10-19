resource "aws_iam_group" "iam_groups" {
  count = length(var.group_names)
  name  = var.group_names[count.index]
}