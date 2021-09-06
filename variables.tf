variable "workspace" {
  description = "Workspace slug or UUID"
  type        = string
}

variable "api_url" {
  description = "Bitbucket API URL"
  type        = string
  default     = "https://api.bitbucket.org/2.0"
}

variable "source_ip" {
  description = <<-EOF
    Source IPs from where OIDC tokens would be accepted. Empty means anywhere.
    
    See https://registry.terraform.io/modules/calidae/ip-addresses/bitbucket/latest
    on how to retrieve Bitbucket outbound IP ranges
EOF
  type        = list(string)
  default     = []
}

variable "policies" {
  description = <<-EOF
    Map with OIDC subjects and other claims to restrict role assumptions.
    
    See https://support.atlassian.com/bitbucket-cloud/docs/deploy-on-aws-using-bitbucket-pipelines-openid-connect/#Using-claims-in-ID-tokens-to-limit-access-to-the-IAM-role-in-AWS
    for some claims that can be used in assume role policies.
EOF
  type = map(object({
    subjects = list(string)
    claims   = map(list(string))
  }))
  default = {
    default = {
      subjects = []
      claims = {}
    }
  }
}
