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
#In terraform we can define variables in multiple way
# 1.default varible
# 2.Environment Variable //using export in linux, macOS and SET or SETX in windows
# 3.tfvars file
# 4.commandline //using -vars "user_prefix=my_user" with terraform apply
# Here commandline has highest priority and default has lowest priority

variable "iam_prefix" {
  default = "terraform"

}
resource "aws_iam_user" "my_users" {
  count = 1
  name  = "${var.iam_prefix}_${count.index}"

}

