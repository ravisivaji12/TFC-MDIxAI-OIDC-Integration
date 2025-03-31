variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "github_organization" {
  description = "GitHub Organization Name"
  type        = string
  default     = "ravisivaji12"
}

variable "template_repo" {
  description = "GitHub Repository Template Name"
  type        = string
  default     = "ravsivaji"
}

variable "new_repo_name" {
  description = "Name of the new repository"
  type        = list(string)
  default     = ["TFC-MDIxAI-REPO-ONE", "TFC-MDIxAI-REPO-TWO"]
}

variable "repo_visibility" {
  description = "Visibility of the repository (private/public)"
  type        = string
  default     = "public"
}

variable "tfc_azure_audience" {
  type        = string
  default     = "api://AzureADTokenExchange"
  description = "The audience value to use in run identity tokens"
}

variable "tfc_hostname" {
  type        = string
  default     = "app.terraform.io"
  description = "The hostname of the TFC or TFE instance you'd like to use with Azure"
}

variable "tfc_organization_name" {
  type        = string
  default     = "SivajiRaavi"
  description = "The name of your Terraform Cloud organization"
}

variable "tfc_project_name" {
  type        = string
  default     = "TFC-MDIxAI-OIDC-Integration"
  description = "The project under which a workspace will be created"
}

variable "tfc_workspace_name" {
  type        = string
  default     = "Production"
  description = "The name of the workspace that you'd like to create and connect to Azure"
}

variable "tfc_configs" {
  description = "Set of configurations for Terraform Cloud workspaces"
  type = set(object({
    app_name          = string
    organization_name = string
    project_name      = string
    workspace_name    = string
  }))
  default = [{
    app_name          = "tfc_application-dev"
    organization_name = "SivajiRaavi"
    project_name      = "my-project"
    workspace_name    = "dev"
    },
    {
      app_name          = "tfc_application-prod"
      organization_name = "SivajiRaavi"
      project_name      = "my-project"
      workspace_name    = "prod"
    },
    {
      app_name          = "tfc_application-staging"
      organization_name = "SivajiRaavi"
      project_name      = "my-project"
      workspace_name    = "staging"
  }]
}

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

