provider "aws" {
  region = var.region
  # access_key = var.AWS_ACCESS_KEY_ID
  # secret_key = var.AWS_SECRET_ACCESS_KEY
}

terraform {
  # cloud {
  #   organization = ""
  #   workspaces {
  #     name = "aws-elb-asg-terraform-launch-template"
  #   }
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}