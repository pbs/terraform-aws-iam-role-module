locals {
  name                        = var.name != null ? var.name : var.product
  role                        = var.use_prefix ? null : local.name
  role_prefix                 = var.use_prefix ? "${local.name}-" : null
  generate_assume_role_policy = var.assume_role_policy == null
  assume_role_policy          = var.assume_role_policy != null ? var.assume_role_policy : data.aws_iam_policy_document.assume_role_policy[0].json

  creator = "terraform"

  tags = merge(
    var.tags,
    {
      Name                                      = local.name
      "${var.organization}:billing:product"     = var.product
      "${var.organization}:billing:environment" = var.environment
      creator                                   = local.creator
      provisioner                               = data.aws_caller_identity.current.user_id
      repo                                      = var.repo
    }
  )
}
