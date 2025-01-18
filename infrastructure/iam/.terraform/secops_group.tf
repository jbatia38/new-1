module "secops_group" {
    source = "../..//modules/iam"

    description                = " This is for secops team"
    group_name                 = "secops_group"
    inline_policy_to_attach    = data.aws_iam_policy_document.secops_inline_policy.json
    managed_policies_to_attach = [
        "arn:aws:iam::aws:policy/ReadOnlyAccess",
        "arn:aws:iam::aws:policy/SecurityAudit",
        "arn:aws:iam::aws:policy/SecurityAudit"
    ]
    policy_name                =  "secops_policy"
}


data "aws_iam_policy_document" "secops_inline_policy" {
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

