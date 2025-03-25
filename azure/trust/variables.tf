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
