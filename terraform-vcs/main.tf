terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
    tfe = {
      version = "~> 0.51.1"
    }
  }
}

provider "github" {
  token = var.github_token
}

provider "tfe" {
  token = var.tfe_token
}

resource "github_repository" "main" {
  name        = "terraform-aws-mini-vpc-managed-by-terraform"
  description = "created while Mo is taking a terraform course"
  visibility  = "private"
}

resource "github_repository_file" "main_main" {
  repository     = github_repository.main.name
  file           = "main.tf"
  content        = file("./files/main.tf")
  commit_message = "Managed by Terraform"
  commit_author  = "mo"
  commit_email   = "idk@gmail.com"
}

resource "github_repository_file" "main_gitignore" {
  repository     = github_repository.main.name
  file           = ".gitignore"
  content        = file("./files/.gitignore")
  commit_message = "Managed by Terraform"
  commit_author  = "mo"
  commit_email   = "idk@gmail.com"
}


resource "tfe_oauth_client" "main" {
  organization     = var.tfe_organization
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_token
  service_provider = "github"
}

resource "tfe_workspace" "workspace_for_above_github_repo" {
  name           = "workspace-for-a-github-repo-managed-by-terraform"
  organization   = var.tfe_organization
  queue_all_runs = false
  vcs_repo {
    branch         = github_repository_file.main_main.branch
    identifier     = "kanguki/${github_repository.main.name}"
    oauth_token_id = tfe_oauth_client.main.oauth_token_id
  }
}
