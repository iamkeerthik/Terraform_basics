terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# resource "aws_vpc" "myvpc" {
#   cidr_block = "10.0.0.0/16"
# }

resource "aws_s3_bucket" "my_bucket" {
    
    bucket = "kirik3254"
    versioning {
      enabled= false
    }
  
}

resource "aws_iam_user" "my_user" {

    name = "terraform_updated"
  
}

