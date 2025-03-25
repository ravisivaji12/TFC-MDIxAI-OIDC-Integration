resource "github_repository" "new_repo" {
  for_each    = toset(var.new_repo_name)
  name        = each.value
  description = "This Repository: ${each.value} for MDIxAI platform has been created and managed using Terraform"
  visibility  = var.repo_visibility
  template {
    owner      = var.org_name
    repository = var.template_repo
  }
  has_issues         = true
  has_wiki           = false
  allow_merge_commit = false
  allow_squash_merge = true
  allow_rebase_merge = false

  vulnerability_alerts   = true # Enable security alerts for dependencies
  delete_branch_on_merge = true

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "github_branch_protection" "main" {
  for_each      = github_repository.new_repo
  repository_id = each.value.node_id //github_repository.new_repo.node_id
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["Lint", "Security Scan", "Build & Test"]
  }

  enforce_admins = true

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}


