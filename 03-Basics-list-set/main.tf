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

variable "names" {
 # default =["arjun", "keerthik", "kenny", "pavan"]
  default =["shyam", "arjun", "kenny", "pavan"]
}
resource "aws_iam_user" "my_users" {
 # count = length(var.names)
 # name  = var.names[count.index]
  for_each = toset(var.names)
  name= each.value
}

