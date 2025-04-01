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
  default     = []
}

variable "repo_visibility" {
  description = "Visibility of the repository (private/public)"
  type        = string
  default     = "public"
}
