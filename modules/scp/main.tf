# Deploy aws SCP using terraform

data "aws_organizations_organization" "current" {}

resource "aws_organizations_policy" "scp-policy" {
  name        = var.policy_name
  content     = var.policy_statement
  description = var.description
  tags        = var.tags
}

resource "aws_organizations_policy_attachment" "account" {
  for_each = toset(var.ou_ids)
  policy_id = aws_organizations_policy.scp-policy.id #getting the attrribute of the policy from line 5
  target_id = each.value
}
