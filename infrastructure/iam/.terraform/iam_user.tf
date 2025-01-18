
resource "aws_iam_user" "my_first_user" {
  name = "Security-user"
}

resource "aws_iam_user" "my_second_user" {
  name = "Cloud-user"
}

resource "aws_iam_group" "security_group" {
  name = "Cloud-Security-Team"
}


resource "aws_iam_group_membership" "team" {
  name  = "terraform-group-membership"

  users = [
    aws_iam_user.my_first_user.name,
    aws_iam_user.my_second_user.name
  ]

  group = aws_iam_group.security_group.name
}
