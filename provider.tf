provider "aws" {
  region = "us-west-2"
}
terraform {
  backend "s3" {} # required - configuration is injected by the pipeline
  required_version = "1.9.5" # required

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.53"
    }
  }
}
