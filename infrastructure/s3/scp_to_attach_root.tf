# Module to deploy SCP policy to the root organizational unit
module "organizational_scp_root" {
  source = "../../modules/scp"

 
  description = "Terraform deploy SCPs to root OU"
  policy_name = "Terraform-root-deployed-policy"
  policy_statement = data.aws_iam_policy_document.root.json
  ou_ids = ["r-sg2p"]

  # Tags to assign to the deployed resources
  tags = {
    creator     = "CloudEngineer"
    email       = "info@cloudteam.com"
    automation  = "Terraform"
    environment = "SANDBOX"
  }
}

# IAM policy document for SCP applied to the root
data "aws_iam_policy_document" "root" {
  statement {
    sid       = "Statement1"
    effect    = "Deny"
    resources = ["*"]
    actions   = ["organizations:LeaveOrganization"]
  }
}
