variable "organization" {
  description = "GitHub organization name"
  type        = string
  default     = "your-org"
}

variable "repository" {
  description = "GitHub repository name"
  type        = string
  default     = ""
}

variable "github_app_pem_path" {
  description = "Path to the GitHub App PEM key in Vault"
  type        = string
  default     = "secret/path/to/github/app/pem"
}

variable "environment" {
  description = "GitHub repository environment name"
  type        = string
  default     = ""
  validation {
    condition     = var.environment == "" || var.repository != ""
    error_message = "if environment is set, repository must also be set"
  }
}

variable "github_svt" {
  description = "Github Secret / Variable / Token Configuration"
  type = object({
    name            = string                     # Name of the secret
    key             = string                     # Key for the secret
    app_id          = optional(number, 0)        # GitHub App ID (if applicable)
    installation_id = optional(number, 0)        # GitHub App Installation ID (if applicable)
    team            = optional(string, "devops") # Team associated with the secret
    visibility      = optional(string, "all")    # Visibility of the secret (e.g., 'all', 'selected')
    repositories    = optional(list(string), []) # List of repository IDs for selected visibility
  })
  default = {
    name = "action_secret_token"
    key  = "vault-key-or-github-app-slug"
  }
  validation {
    error_message = "if type is token, app_id and installation_id must be set"
    condition     = var.type != "token" || (var.github_svt.app_id > 0 && var.github_svt.installation_id > 0)
  }
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.github_svt.name)) && !can(regex("^GITHUB_", var.github_svt.name))
    error_message = "Invalid name. It must start with a letter and contain only alphanumeric characters and underscores, and must not start with 'GITHUB_'."
  }
  validation {
    condition     = contains(["all", "private", "selected"], var.github_svt.visibility)
    error_message = "Invalid visibility. Allowed values are: 'all', 'private', 'selected'."
  }
  validation {
    condition     = contains(["all", "private"], var.github_svt.visibility) || length(var.github_svt.repositories) > 0
    error_message = "values for 'repositories' must be provided when visibility is 'selected'."
  }
}

variable "type" {
  description = "Type of the GitHub Actions configuration"
  # possible values: 'secret', 'variable', 'token'
  type    = string
  default = "secret"
  validation {
    condition     = contains(["secret", "variable", "token"], var.type)
    error_message = "Invalid type. Allowed values are: 'secret', 'variable', 'token'."
  }
}
