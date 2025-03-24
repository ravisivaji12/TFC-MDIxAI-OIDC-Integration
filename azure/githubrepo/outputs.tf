output "repository_url" {
  //value = github_repository.new_repo.html_url
  value = { for repo_name, repo in github_repository.new_repo : repo_name => repo.html_url }
}
