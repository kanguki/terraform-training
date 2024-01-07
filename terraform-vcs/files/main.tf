terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "whatever" {
  cidr_block = "10.0.0.0/16"

}
