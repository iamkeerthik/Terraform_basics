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

//S3 bucket
resource "aws_s3_bucket" "enterprise_backend_state" {
  bucket = "dev-backend-state-kirik2552"
  lifecycle {
    #prevent_destroy = true //comment it before destroy
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

}

//Locking-Dynamo DB -only one user can update the state at a time
resource "aws_dynamodb_table" "enterprise_backend_lock" {
  name = "dev_application_locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name="LockID"
    type="S"
  }
  
}