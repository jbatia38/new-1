resource "aws_cloudformation_stack_set" "access_key_check_stackset" {
  name             = "StackSetAccessKeyComplianceCheck"
  capabilities     = ["CAPABILITY_NAMED_IAM"]
  description      = "Deploy IAM role to all AWS accounts in the Organization"
  permission_model = "SERVICE_MANAGED"
  call_as          = "SELF"
  tags             = var.tags
  template_body    = file("./yaml/iam_role_access_key_check.yml")

  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = false
  }

  parameters = {
    CentralizedAccountId = var.CentralizedAccountId
    RoleName             = var.RoleName
  }

  operation_preferences {
    failure_tolerance_percentage = 100
    max_concurrent_percentage    = 75
  }

  managed_execution {
    active = true
  }

  timeouts {
    update = "4h"
  }
}

resource "aws_cloudformation_stack_instances" "example" {
  for_each       = toset(var.ou_ids)
  regions        = [var.region]
  call_as        = "SELF"
  stack_set_name = aws_cloudformation_stack_set.access_key_check_stackset.name

  deployment_targets {
    organizational_unit_ids = [each.key]
  }

  operation_preferences {
    failure_tolerance_percentage = 100
    max_concurrent_percentage    = 75
  }
}
