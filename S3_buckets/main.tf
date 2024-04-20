provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "project_terraform_state_file"

  #to prevent accidental deletion of the s3 bucket
  lifecycle {
    prevent_destroy = true
  }
}

#The versioning is created so that the state file revision history is visible
resource "aws_s3_bucket_versioning" "state_file_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

#Enable server side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "project_s3_default_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
    }
  }
}

# Explicitly block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
bucket = aws_s3_bucket.terraform_state.id
block_public_acls = true
block_public_policy = true
ignore_public_acls = true
restrict_public_buckets = true
}