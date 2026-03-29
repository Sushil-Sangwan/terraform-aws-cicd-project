terraform {
  backend "s3" {
    bucket = "sushil-terraform-state-12345"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region     = "us-east-1"
}