#provider
provider "aws" {
  region = var.region
}
# creating RDS database instance
resource "aws_db_instance" "project_database" {
  allocated_storage = var.database.allocated_storage
  storage_type = var.database.storage_type
  engine = var.database.engine
  engine_version = var.database.engine_version
  instance_class = var.database.instance_class

  #setting the database username and password
  username = var.db_login.username
  password = var.db_login.password

  vpc_security_group_ids = [aws_security_group.project_security]
  db_subnet_group_name = aws_subnet.project_subnet.name


  skip_final_snapshot = true // required to destroy

  # Enable enhanced monitoring
  monitoring_interval = 60 # Interval in seconds (minimum 60 seconds)
  monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn

  # Enable performance insights
  performance_insights_enabled = true
}

# Define AWS IAM Role for RDS Monitoring
resource "aws_iam_role" "rds_monitoring_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
  Version = "2012-10-17",
  Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
        Service = var.service_principal
      }
    }
  ]
})
}

# Attach AWS IAM Policy to Role
resource "aws_iam_policy_attachment" "rds_monitoring_attachment" {
  name = "rds-monitoring-attachment"
  roles = [aws_iam_role.rds_monitoring_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

terraform {
  backend "s3" {
    #S3 bucket information
    bucket = "project_terraform_state_file"
    key = "Stage/data-stores/RDS/terraform.tfstate"
    region = "eu-central-1"

    dynamodb_table = "project_state_terraform_locks"
    encrypt = true
  }
}