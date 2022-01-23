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

terraform {
  backend "s3" {
    bucket = "dev-backend-state-kirik2552"
    key            = "08-backend-state-users-dev" 
    # key            = "dev/08-backend-state/users/backend-state" // we can spevify like this also
    region         = "us-east-1"
    dynamodb_table = "dev_application_locks"
    encrypt        = true
  }
}

resource "aws_iam_user" "my_user" {

  name = "${terraform.workspace}_terraform_user"

}

//after changing backend to remote we have to run -> terraform init 
//because now it will store backend remotly