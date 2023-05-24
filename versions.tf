terraform {
  required_version = ">= 1.0"
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