module "devops_group" {
    source = "../..//modules/iam"

    description                = " This is for devops team"
    group_name                 = "devops_group"
    inline_policy_to_attach    = data.aws_iam_policy_document.devops_inline_policy.json
    managed_policies_to_attach = [
        "arn:aws:iam::aws:policy/ReadOnlyAccess"
    ]
    policy_name                =  "devops_policy"
}


data "aws_iam_policy_document" "devops_inline_policy" {
    statement {
    sid       = "Statement1"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "cloudtrail:*",
      "cloudwatch:*",
    ]
  }
}