
data "tls_certificate" "bitbucket" {
  url = var.api_url
}

data "http" "workspace" {
  url = "${var.api_url}/workspaces/${var.workspace}"
}

locals {
  workspace      = jsondecode(data.http.workspace.body)
  workspace_uuid = trim(local.workspace.uuid, "}{")
  audience       = "ari:cloud:bitbucket::workspace/${local.workspace_uuid}"
  url            = "${var.api_url}/workspaces/${local.workspace.slug}/pipelines-config/identity/oidc"
  oidc           = trimprefix(local.url, "https://")
}

resource "aws_iam_openid_connect_provider" "bitbucket" {
  url             = local.url
  client_id_list  = [local.audience]
  thumbprint_list = [
    for cert in data.tls_certificate.bitbucket.certificates :
    cert.sha1_fingerprint
  ]
}

data "aws_iam_policy_document" "assume_role_with_webid" {
  for_each = var.policies
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.bitbucket.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.oidc}:aud"
      values   = [local.audience]
    }
    dynamic "condition" {
      for_each = each.value.subjects
      content {
        test     = "StringLike"
        variable = "${local.oidc}:sub"
        values   = [condition.value]
      }
    }
    dynamic "condition" {
      for_each = each.value.claims
      content {
        test     = "StringLike"
        variable = "${local.oidc}:${condition.key}"
        values   = condition.value
      }
    }
    dynamic "condition" {
      for_each = tobool(length(var.source_ip) > 0) ? [true] : []
      content {
        test     = "IpAddress"
        variable = "aws:SourceIp"
        values   = var.source_ip
      }
    }
  }
}
