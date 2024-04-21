provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "project_s3_bucket" {
  bucket = "project_terraform_state_file"

  #to prevent accidental deletion of the s3 bucket
  lifecycle {
    prevent_destroy = true
  }
}

#The versioning is created so that the state file revision history is visible
resource "aws_s3_bucket_versioning" "project_state_file_versioning" {
  bucket = aws_s3_bucket.project_s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

#Enable server side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "project_s3_default_encryption" {
  bucket = aws_s3_bucket.project_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
    }
  }
}

# Explicitly block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
bucket = aws_s3_bucket.project_s3_bucket.id
block_public_acls = true
block_public_policy = true
ignore_public_acls = true
restrict_public_buckets = true
}

#This enables us to perrform terraform locking
resource "aws_dynamodb_table" "terraform_locks" {
    name = "project_state_terraform_locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}

terraform {
  backend "s3" {
    #S3 bucket information
    bucket = "project_terraform_state_file"
    key = "Global/S3_buckets/terraform.tfstate"
    region = "eu-central-1"
   #TODO copy the bucket region dynamodb_table and encrypt to a file named backend.hcl for all the s3 backend storage
    dynamodb_table = "project_state_terraform_locks"
    encrypt = true
  }
}