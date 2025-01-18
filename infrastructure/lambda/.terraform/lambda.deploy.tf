module "disable_inactive_users" {
  source                  = "../../modules/lambda"
  aws_region              = "us-east-1"
  lambda_function_name    = "disable_inactive_users"
  iam_role_name           = "lambda_iam_user_audit_role"
  inactive_days_threshold = 2
 }
