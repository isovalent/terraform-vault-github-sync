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
