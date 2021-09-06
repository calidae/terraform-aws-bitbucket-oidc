provider "aws" {}

module "bitbucket_oidc" {
  source    = "calidae/bitbucket-oidc/aws"
  workspace = "mywspace"
}

resource "aws_iam_role" "bitbucket" {
  name               = "example"
  description        = "Example"
  assume_role_policy = module.bitbucket_oidc.json_policies.default
}
