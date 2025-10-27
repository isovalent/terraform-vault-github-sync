terraform {
  required_version = ">= 1.5.0"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.1.0"
    }

    github = {
      source  = "integrations/github"
      version = ">= 6.7"
    }

    sodium = {
      source  = "killmeplz/sodium"
      version = "0.0.3"
    }
  }
}

