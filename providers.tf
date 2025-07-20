terraform {
  required_version = ">= 1.5.0"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.1.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

