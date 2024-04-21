output "s3_bucket_arn" {
value = aws_s3_bucket.project_s3_bucket.arn
description = "The ARN of the S3 bucket"
}
output "dynamodb_table_name" {
value = aws_dynamodb_table.terraform_locks.name
description = "The name of the DynamoDB table"
}

output "address" {
value = aws_db_instance.project_database.address
description = "Connect to the database at this endpoint"
}
output "port" {
value = aws_db_instance.project_database.port
description = "The port the database is listening on"
}