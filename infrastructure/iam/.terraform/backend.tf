# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "development-team-2024"
    dynamodb_table = "my-lock-table"
    encrypt        = true
    key            = "iam/terraform"
    region         = "us-east-1"
  }
}
