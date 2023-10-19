resource "aws_iam_user" "bb_user" {
  for_each = toset(var.user_names)
  name     = each.key
}