mock_provider "aws" {
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
    }
  }
}

run "scoped_subject_ok" {
  command = plan
  variables {
    roles = {
      gha-plan = { subjects = ["repo:acme/infra-live:pull_request"] }
    }
  }
  assert {
    condition     = length(aws_iam_role.this) == 1
    error_message = "Deveria criar 1 role."
  }
}

run "org_wildcard_rejected" {
  command = plan
  variables {
    roles = {
      bad = { subjects = ["repo:acme/*"] }
    }
  }
  expect_failures = [var.roles]
}
