/*
# Define user names for each team
variable "security_team_users" {
  type    = list(string)
  default = ["Security11", "Security22", "Security33", "Security44", "Security55"]
}

variable "devops_team_users" {
  type    = list(string)
  default = ["DevOps11", "DevOps22", "DevOps33", "DevOps44", "DevOps44"]
}

# Create IAM users dynamically for both teams
resource "aws_iam_user" "users" {
  for_each = toset(concat(var.security_team_users, var.devops_team_users))
  name     = each.value
  tags = {
    Owner = "GroupB"
  }
}

# Create IAM groups for DevOps and Security teams
resource "aws_iam_group" "devops" {
  name = "DevOps-Team"
}

resource "aws_iam_group" "security" {
  name = "Security-Team"
}

# Add Security team users to the Security group
resource "aws_iam_group_membership" "security_team_membership" {
  name  = "security-team-membership"
  group = aws_iam_group.security.name
  users = var.security_team_users
}

# Add DevOps team users to the DevOps group
resource "aws_iam_group_membership" "devops_team_membership" {
  name  = "devops-team-membership"
  group = aws_iam_group.devops.name
  users = var.devops_team_users
}
*/