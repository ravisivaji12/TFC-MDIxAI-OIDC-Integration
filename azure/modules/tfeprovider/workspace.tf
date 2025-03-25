resource "tfe_workspace" "azure_workspace" {
  for_each     = var.workspaces
  name         = each.key
  organization = var.organization
  project_id   = tfe_project.azure_project.id

  vcs_repo {
    identifier                 = "ravisivaji12/tfc-azure-example" # GitHub Org/Repo
    branch                     = "main"                           # Default branch
    github_app_installation_id = var.github_app_installation_id   # GitHub App installation ID
  }
}
