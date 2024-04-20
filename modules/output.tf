output "public_ip" {
  value = aws_lb.project_load_balancer.dns_name
  description = "This is the load balancer domain name"
}

# The s3 bucket name derived from the prefix
output "s3_bucket_name" {
  value = aws_s3_bucket.bucket.id
}