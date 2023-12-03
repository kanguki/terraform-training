terraform {
  backend "remote" {
    organization = "moyi"

    workspaces {
      name = "moyi-follow-more-than-certified"
    }
  }
}