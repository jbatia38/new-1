module "developer_group" {
    source = "../..//modules/iam"

    description                = " This is for codeveloper team"
    group_name                 = "developer_group"
    inline_policy_to_attach    = data.aws_iam_policy_document.developer_inline_policy.json
    managed_policies_to_attach = [    
        "arn:aws:iam::aws:policy/ReadOnlyAccess"
    ]
    policy_name                =  "developer_policy"
}


data "aws_iam_policy_document" "developer_inline_policy" {
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