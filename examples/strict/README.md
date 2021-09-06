Create a bitbucket provider and request different json policies
that can only be assumed from whitelisted repositories, branches
and deployment environments.

See
https://support.atlassian.com/bitbucket-cloud/docs/deploy-on-aws-using-bitbucket-pipelines-openid-connect/#Using-claims-in-ID-tokens-to-limit-access-to-the-IAM-role-in-AWS
for usable claims in Bitbucket's JWT.

Also use
https://registry.terraform.io/modules/calidae/ip-addresses/bitbucket/latest
to demonstrate IP whitelisting.
