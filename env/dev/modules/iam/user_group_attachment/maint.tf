resource "aws_iam_group_membership" "bb_team_0" {
  name = "group-membership-0"
  count = length(var.group_0)
  users = [
    var.user_0
  ]
  group = var.group_0[count.index]
}

resource "aws_iam_group_membership" "bb_team_1" {
  name = "group-membership-1"
  count = length(var.group_1)
  users = [
    var.user_1
  ]
  group = var.group_1[count.index]
}

resource "aws_iam_group_membership" "bb_team_2" {
  name = "group-membership-2"
  count = length(var.group_2)
  users = [
    var.user_2
  ]
  group = var.group_2[count.index]
}

resource "aws_iam_group_membership" "bb_team_3" {
  name = "group-membership-3"
  count = length(var.group_3)
  users = [
    var.user_3
  ]
  group = var.group_3[count.index]
}

resource "aws_iam_group_membership" "bb_team_4" {
  name = "group-membership-4"
  count = length(var.group_4)
  users = [
    var.user_4
  ]
  group = var.group_4[count.index]
}

resource "aws_iam_group_membership" "bb_team_5" {
  name = "group-membership-5"
  count = length(var.group_5)
  users = [
    var.user_5
  ]
  group = var.group_5[count.index]
}