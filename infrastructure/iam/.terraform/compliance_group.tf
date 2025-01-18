module "compliance_group" {
    source = "../..//modules/iam"

    description                = " This is for compliance team"
    group_name                 = "compliance_group"
    inline_policy_to_attach    = data.aws_iam_policy_document.compliance_inline_policy.json
    # managed_policies_to_attach 
    policy_name                =  "compliance_audit_acess"
}


data "aws_iam_policy_document" "compliance_inline_policy" {
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