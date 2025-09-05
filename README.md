# Vault - Github Secrets Syncer

This Terraform module manages GitHub Actions secrets and variables at different scopes (`organization`, `repository`, `environment`).

Care has been taken to handle all the functionality of secrets and variable creation. This module does not cover management of `dependabot` secrets and variables.

## Organization Secrets and Variables

An organization secret / variable creation operation has the following knobs to customize the visibility.

* visibility - `all`, `private`, `selected`
* repositories - a list of repositories to which the item should be scoped. (applicable only for `selected` visibility)

## Repository Secrets and Variables

A Repository Secret is available to the repository in question. Can have the same name as the Organization secret / variable.
This has precedence over the org secret / variable.

## Environment Secrets and Variables

An Environment Secret is available to the specific environment in question. Can have the same name as Org and/or Repo secret / variable.
This has precedence over secrets/variable the other two aforementioned scopes.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.0 |
| <a name="requirement_sodium"></a> [sodium](#requirement\_sodium) | 0.0.3 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 5.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | ~> 6.0 |
| <a name="provider_sodium"></a> [sodium](#provider\_sodium) | 0.0.3 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | ~> 5.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_actions_environment_secret.secret](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_variable.variable](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_variable) | resource |
| [github_actions_organization_secret.secret](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_secret) | resource |
| [github_actions_organization_variable.variable](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_variable) | resource |
| [github_actions_secret.secret](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_variable.variable](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable) | resource |
| [github_actions_organization_public_key.org_public_key](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/actions_organization_public_key) | data source |
| [github_actions_public_key.repo_public_key](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/actions_public_key) | data source |
| [github_app_token.app_token](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/app_token) | data source |
| [github_repository.selected_repositories](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository) | data source |
| [sodium_encrypted_item.encrypted_item](https://registry.terraform.io/providers/killmeplz/sodium/0.0.3/docs/data-sources/encrypted_item) | data source |
| [vault_generic_secret.app_key](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.secret](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | GitHub repository environment name | `string` | `""` | no |
| <a name="input_github_app_pem_path"></a> [github\_app\_pem\_path](#input\_github\_app\_pem\_path) | Path to the GitHub App PEM key in Vault | `string` | `"secret/path/to/github/app/pem"` | no |
| <a name="input_github_svt"></a> [github\_svt](#input\_github\_svt) | Github Secret / Variable / Token Configuration | <pre>object({<br/>    name            = string                     # Name of the secret<br/>    key             = string                     # Key for the secret<br/>    path            = optional(string, "")       # Path to the secret in Vault (overrides default path construction)<br/>    app_id          = optional(number, 0)        # GitHub App ID (if applicable)<br/>    installation_id = optional(number, 0)        # GitHub App Installation ID (if applicable)<br/>    team            = optional(string, "devops") # Team associated with the secret<br/>    visibility      = optional(string, "all")    # Visibility of the secret (e.g., 'all', 'selected')<br/>    repositories    = optional(list(string), []) # List of repository IDs for selected visibility<br/>  })</pre> | <pre>{<br/>  "key": "vault-key-or-github-app-slug",<br/>  "name": "action_secret_token"<br/>}</pre> | no |
| <a name="input_organization"></a> [organization](#input\_organization) | GitHub organization name | `string` | `"your-org"` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | GitHub repository name | `string` | `""` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of the GitHub Actions configuration | `string` | `"secret"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_svt_path"></a> [github\_svt\_path](#output\_github\_svt\_path) | GitHub SVT Path |
<!-- END_TF_DOCS -->
