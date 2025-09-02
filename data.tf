# fetch github org public key for use with secrets
data "github_actions_organization_public_key" "org_public_key" {
}

# fetch repo public key for use with secrets
data "github_actions_public_key" "repo_public_key" {
  count      = var.repository != "" ? 1 : 0
  repository = var.repository
}


# fetch secret from vault
data "vault_generic_secret" "secret" {
  count = var.type != "token" ? 1 : 0
  path  = "secret/${var.github_svt.team}/${var.organization}${var.repository != "" ? "/${var.repository}" : ""}${var.environment != "" ? "/${var.environment}" : ""}"
}

# fetch repository IDs for selected visibility
data "github_repository" "selected_repositories" {
  for_each = var.github_svt.visibility == "selected" ? toset(var.github_svt.repositories) : []

  full_name = "${var.organization}/${each.value}"
}

# Get github app pem key from Vault
data "vault_generic_secret" "app_key" {
  count = var.type == "token" ? 1 : 0
  path  = var.github_app_pem_path
}

# Generate GitHub App token
data "github_app_token" "app_token" {
  count           = var.type == "token" ? 1 : 0
  app_id          = var.github_svt.app_id
  installation_id = var.github_svt.installation_id
  pem_file        = data.vault_generic_secret.app_key[0].data[var.github_svt.key]
}

data "sodium_encrypted_item" "encrypted_item" {
  count = var.type != "variable" ? 1 : 0

  public_key_base64 = (
    var.repository == "" ?
    data.github_actions_organization_public_key.org_public_key.key :
    data.github_actions_public_key.repo_public_key[0].key
  )

  content_base64 = base64encode(
    var.type == "secret" ?
    data.vault_generic_secret.secret[0].data[var.github_svt.key] :
    data.github_app_token.app_token[0].token
  )
}
