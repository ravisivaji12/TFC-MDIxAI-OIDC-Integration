terraform {

  /*   cloud {
    organization = "Mccain_Foods"

    workspaces {
      name = "Development"
    }
  } */

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.44.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.34.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.1.0"
}
