variable "github_token" {
  type        = string
  description = "github token to create a github repo and oauth terraform. should be granted enough rights to create and destroy a repo"
  sensitive   = true
}

variable "tfe_token" {
  type        = string
  description = "tfe token to interact with tfe"
  sensitive   = true
}

variable "tfe_organization" {
  type        = string
  description = "terraform organization used to create workspaces"
  sensitive   = true
}


