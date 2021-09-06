output "json_policies" {
  description = "JSON policies map. Will contain a 'default' key with a secure yet naive policy unless the policies variable is specified."
  value = {
    for key, doc in data.aws_iam_policy_document.assume_role_with_webid :
    key => doc.json
  }
}

output "arn" {
    description = "Provider ARN"
    value       = aws_iam_openid_connect_provider.bitbucket.arn
}

output "audience" {
    description = "Expected audience OIDC claim"
    value       = local.audience
}
