# Create variables for each workspace dynamically
resource "tfe_variable" "workspace_vars" {
  for_each = var.workspaces

  workspace_id = tfe_workspace.azure_workspace[each.key].id
  key          = "ARM_SUBSCRIPTION_ID"
  value        = each.value.ARM_SUBSCRIPTION_ID
  sensitive    = true
  category     = "env"
}

resource "tfe_variable" "workspace_varsclient" {
  for_each = var.workspaces

  workspace_id = tfe_workspace.azure_workspace[each.key].id
  key          = "ARM_CLIENT_ID"
  value        = each.value.ARM_CLIENT_ID
  sensitive    = true
  category     = "env"
}

resource "tfe_variable" "workspace_varsauth" {
  for_each = var.workspaces

  workspace_id = tfe_workspace.azure_workspace[each.key].id
  key          = "TFC_AZURE_PROVIDER_AUTH"
  value        = each.value.TFC_AZURE_PROVIDER_AUTH
  sensitive    = true
  category     = "env"
}

resource "tfe_variable" "workspace_varsghtoken" {
  for_each = var.workspaces

  workspace_id = tfe_workspace.azure_workspace[each.key].id
  key          = "GITHUB_TOKEN"
  value        = each.value.GITHUB_TOKEN
  sensitive    = true
  category     = "env"
}

resource "tfe_variable" "workspace_varstenantid" {
  for_each = var.workspaces

  workspace_id = tfe_workspace.azure_workspace[each.key].id
  key          = "ARM_TENANT_ID"
  value        = each.value.ARM_TENANT_ID
  sensitive    = true
  category     = "env"
}