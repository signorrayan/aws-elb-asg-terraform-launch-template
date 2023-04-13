terraform {
  cloud {
    organization = "signorrayan"
    workspaces {
      name = "aws-elb-asg-terraform-launch-template"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}