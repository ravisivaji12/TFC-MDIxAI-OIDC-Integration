variable "organization" {
  description = "Terraform Cloud Organization Name"
  type        = string
  default     = "SivajiRaavi"
}

variable "tfe_token" {
  description = "Terraform Personal Access Token"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Terraform Cloud Project Name"
  type        = string
  default     = "Azure Multi-Env Project"
}

variable "github_app_installation_id" {
  description = "GitHub App Installation ID"
  type        = string
  sensitive   = true
}

variable "workspaces" {
  description = "Map of workspaces and their associated variables."
  type = map(object({
    ARM_SUBSCRIPTION_ID     = string
    ARM_CLIENT_ID           = string
    ARM_TENANT_ID           = string
    TFC_AZURE_PROVIDER_AUTH = string
    GITHUB_TOKEN            = string
  }))
}


/* variable "workspace_names" {
  description = "List of workspaces"
  type        = list(string)
  default     = ["dev", "staging", "prod"]
} */

/* variable "environment_variables" {
  description = "Environment variables for workspaces"
  type        = map(map(string))
  default = {
    dev = {
      ARM_SUBSCRIPTION_ID     = ""
      ARM_CLIENT_ID           = ""
      ARM_TENANT_ID           = ""
      TFC_AZURE_PROVIDER_AUTH = "true"
      GITHUB_TOKEN            = ""
    }
    staging = {
      ARM_SUBSCRIPTION_ID     = ""
      ARM_CLIENT_ID           = ""
      ARM_TENANT_ID           = ""
      TFC_AZURE_PROVIDER_AUTH = "true"
      GITHUB_TOKEN            = ""
    }
    prod = {
      ARM_SUBSCRIPTION_ID     = ""
      ARM_CLIENT_ID           = ""
      ARM_TENANT_ID           = ""
      TFC_AZURE_PROVIDER_AUTH = "true"
      GITHUB_TOKEN            = ""
    }
  }
} */

/* variable "environment_variables" {
  description = "Environment variables for workspaces"
  type = map(object({
    workspace_id = string
    variables    = map(string)
  }))
  default = {
    dev = {
      workspace_id = "ws-dev-12345"
      variables = {
        ARM_SUBSCRIPTION_ID     = ""
        ARM_CLIENT_ID           = ""
        ARM_TENANT_ID           = ""
        TFC_AZURE_PROVIDER_AUTH = "true"
        GITHUB_TOKEN            = ""
      }
    }
    staging = {
      workspace_id = "ws-dev-12345"
      variables = {
        ARM_SUBSCRIPTION_ID     = ""
        ARM_CLIENT_ID           = ""
        ARM_TENANT_ID           = ""
        TFC_AZURE_PROVIDER_AUTH = "true"
        GITHUB_TOKEN            = ""
      }
    }
    prod = {
      workspace_id = "ws-dev-12345"
      variables = {
        ARM_SUBSCRIPTION_ID     = ""
        ARM_CLIENT_ID           = ""
        ARM_TENANT_ID           = ""
        TFC_AZURE_PROVIDER_AUTH = "true"
        GITHUB_TOKEN            = ""
      }
    }
  }
}
 */