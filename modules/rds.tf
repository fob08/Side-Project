# creating RDS database instance
resource "aws_db_instance" "default" {
  allocated_storage = 10
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"


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
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
  Version = "2012-10-17",
  Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
        Service = "monitoring.rds.amazonaws.com"
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