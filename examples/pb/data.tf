data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "policy_document" {
  statement {
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:CreatePolicy",
      "iam:DeletePolicy",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:CreatePolicyVersion",
      "iam:DeletePolicyVersion",
      "iam:SetDefaultPolicyVersion",
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/example-lambda-role-*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/example-lambda-role-*",
    ]
  }
}

# Based off of https://aws.amazon.com/premiumsupport/knowledge-center/iam-permission-boundaries/
data "aws_iam_policy_document" "permissions_boundary_policy_document" {
  statement {
    actions = [
      "*",
    ]
    resources = [
      "*",
    ]
  }
  statement {
    actions = [
      "account:*",
      "aws-portal:*",
      "savingsplans:*",
      "cur:*",
      "ce:*",
    ]
    resources = [
      "*",
    ]
  }
  statement {
    effect = "Deny"
    actions = [
      "iam:DeletePolicy",
      "iam:DeletePolicyVersion",
      "iam:CreatePolicyVersion",
      "iam:SetDefaultPolicyVersion",
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${local.permission_boundary_name}",
    ]
  }
  statement {
    effect = "Deny"
    actions = [
      "iam:DeleteUserPermissionsBoundary",
      "iam:DeleteRolePermissionsBoundary",
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "iam:PermissionsBoundary"
      values = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${local.permission_boundary_name}",
      ]
    }
  }
  statement {
    effect = "Deny"
    actions = [
      "iam:PutUserPermissionsBoundary",
      "iam:PutRolePermissionsBoundary",
      "iam:CreateUser",
      "iam:CreateRole",
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*",
    ]
    condition {
      test     = "StringNotEquals"
      variable = "iam:PermissionsBoundary"
      values = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${local.permission_boundary_name}",
      ]
    }
  }
  statement {
    effect = "Deny"
    actions = [
      "iam:PassRole",
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*",
    ]
  }
}

