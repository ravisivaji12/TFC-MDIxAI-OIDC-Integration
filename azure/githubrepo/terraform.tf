terraform {
  /*   cloud {
    organization = "Mccain_Foods"

    workspaces {
      name = "Development"
    }
  } */
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.1.0"
}

provider "github" {
  token = var.github_token != "" ? var.github_token : getenv("GITHUB_TOKEN")  
}