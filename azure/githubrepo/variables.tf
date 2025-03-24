variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "org_name" {
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
  default = ["TFC-MDIxAI-REPO-ONE", "TFC-MDIxAI-REPO-TWO"]
}

variable "repo_visibility" {
  description = "Visibility of the repository (private/public)"
  type        = string
  default     = "public"
}
