# create a github_actions_organization_secret
resource "github_actions_organization_secret" "secret" {
  count = (
    var.type != "variable"
    && var.repository == ""
    ? 1 : 0
  )

  visibility = var.github_svt.visibility
  selected_repository_ids = [
    for repo in data.github_repository.selected_repositories :
    repo.repo_id if contains(var.github_svt.repositories, repo.name)
    && repo.name != null
  ]

  secret_name = upper(var.github_svt.name)
  plaintext_value = (
    var.type == "secret"
    ? data.vault_generic_secret.secret[0].data[var.github_svt.key]
    : data.github_app_token.app_token[0].token
  )
}

# create a github_actions_organization_variable
resource "github_actions_organization_variable" "variable" {
  count = var.type == "variable" && var.repository == "" ? 1 : 0

  visibility = var.github_svt.visibility
  selected_repository_ids = [
    for repo in data.github_repository.selected_repositories :
    repo.repo_id if contains(var.github_svt.repositories, repo.name)
    && repo.name != null
  ]

  variable_name = upper(var.github_svt.name)
  value         = data.vault_generic_secret.secret[0].data[var.github_svt.key]
}

# create a github_actions_secret
resource "github_actions_secret" "secret" {
  count = (
    var.type != "variable"
    && var.repository != ""
    && var.environment == "" ? 1 : 0
  )

  repository = var.repository

  secret_name = upper(var.github_svt.name)
  plaintext_value = (
    var.type == "secret"
    ? data.vault_generic_secret.secret[0].data[var.github_svt.key]
    : data.github_app_token.app_token[0].token
  )
}

# create a github_actions_variable
resource "github_actions_variable" "variable" {
  count = (
    var.type == "variable"
    && var.repository != ""
    && var.environment == ""
    ? 1 : 0
  )

  repository = var.repository

  variable_name = upper(var.github_svt.name)
  value         = data.vault_generic_secret.secret[0].data[var.github_svt.key]
}

# create a github_actions_environment_secret for specific environments
resource "github_actions_environment_secret" "secret" {
  count = (
    var.type != "variable"
    && var.repository != ""
    && var.environment != ""
    ? 1 : 0
  )

  repository  = var.repository
  environment = var.environment

  secret_name = upper(var.github_svt.name)
  plaintext_value = (
    var.type == "secret"
    ? data.vault_generic_secret.secret[0].data[var.github_svt.key]
    : data.github_app_token.app_token[0].token
  )
}


# create a github_actions_environment_variable for specific environments
resource "github_actions_environment_variable" "variable" {
  count = (
    var.type == "variable"
    && var.repository != ""
    && var.environment != "" ? 1 : 0
  )

  repository  = var.repository
  environment = var.environment

  variable_name = upper(var.github_svt.name)
  value         = data.vault_generic_secret.secret[0].data[var.github_svt.key]
}
