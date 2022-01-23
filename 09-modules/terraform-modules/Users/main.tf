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

variable "environment" { //global variables can be overriden from anywhere
  default = "default"

}
resource "aws_iam_user" "my_user" {

  # name = "terraform_user_${var.environment}"
  name = "${local.iam_user_extension}_${var.environment}"

}

locals { // local variables no one can override this from outside this specific module
  iam_user_extension = "terraform_user"
}