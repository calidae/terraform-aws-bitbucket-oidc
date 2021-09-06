provider "aws" {}

module "bitbucket_ips" {
  source = "calidae/ip-addresses/bitbucket"
}

module "bitbucket_oidc" {
  source    = "calidae/bitbucket-oidc/aws"
  workspace = "mywspace"
  source_ip = module.bitbucket_ips.ipv4_range
  policies = {
    general = {
      subjects = ["{REPOSITORY_A_UUID}:*", "{REPOSITORY_B_UUID}:*"]
      claims   = {}
    }
    production = {
      subjects = ["{REPOSITORY_X_UUID}:{ENVIRONMENT_UUID}:*"]
      claims = {
        branchName            = ["master", "release/*"],
        deploymentEnvironment = ["production"],
      }
    }
  }
}

resource "aws_iam_role" "bitbucket_ro" {
  name                = "example-readonly"
  description         = "Example"
  assume_role_policy  = module.bitbucket_oidc.json_policies.general
  managed_policy_arns = ["arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"]

}

resource "aws_iam_role" "bitbucket_power" {
  name                = "bitbucket-power"
  description         = "Example"
  assume_role_policy  = module.bitbucket_oidc.json_policies.production
  managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]
}

