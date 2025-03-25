resource "tfe_project" "azure_project" {
  organization = var.organization
  name         = var.project_name
}
