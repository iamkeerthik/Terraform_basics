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

variable "users" {
  default = {
    kiran : { country : "India", department : "IT" },
    kenny : { country : "US", department : "Finance" },
    pavan : { country : "Japan", department : "Transport" }
  }

}

resource "aws_iam_user" "my_users" {
  for_each = var.users
  name     = each.key
  tags = {
    #"Country" = each.value
    Country    = each.value.country
    Department = each.value.department
  }

}