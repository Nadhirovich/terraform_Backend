terraform {
required_version = ">= 0.13"

# add a backend config to To configure Terraform to store the state in an S3 bucket

backend "s3" {
bucket = "my-test-buacket"
key = "global/s3/terraform.tfstate"
region = "us-east-2"
dynamodb_table = "terraform-up-and-running-locks"
encrypt = true
}
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "Tbessa-nadhirovich-bucket" {
bucket = var.bucket_name
# Prevent accidental deletion of this S3 bucket
lifecycle {
prevent_destroy = true
}
# Enable versioning so we can see the full revision
#history of our
# state files
versioning {
enabled = true
}
# Enable server-side encryption by default
server_side_encryption_configuration {
rule {
apply_server_side_encryption_by_default {
sse_algorithm = "AES256"
}
}
}
}

# create a DynamoDB table that has a primary key called LockID to use for locking

resource "aws_dynamodb_table" "terraform_locks" {
name = var.table_name
billing_mode = "PAY_PER_REQUEST"
hash_key = "LockID"
attribute {
name = "LockID"
type = "S"
}
}




