

module "githubrepo" {
  source          = "./modules/githubrepo"
  new_repo_name   = ["repo1", "repo2", "repo3"]
  repo_visibility = "private"
  org_name        = "my-org"
  template_repo   = "template-repo"
  github_token    = var.github_token
}

# output "repository_urls" {
#   value = module.githubrepo.repository_urls
# }

# output "branch_protection_ids" {
#   value = module.githubrepo.branch_protection_ids
# }

module "azuretrust" {
    source = "./modules/trust"
  
}

/* module "tfeprovider" {
    source = "./modules/tfeprovider"
    tfe_token = var.tfe_token
    tfe_org = var.tfe_org
    tfe_workspace = var.tfe_workspace
    tfe_configs = var.tfe_configs
  
} */