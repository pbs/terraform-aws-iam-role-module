module "role" {
  source = "../.."

  policy_json  = data.aws_iam_policy_document.policy_document.json
  aws_services = ["lambda"]

  environment  = var.environment
  product      = var.product
  repo         = var.repo
  organization = var.organization
}
