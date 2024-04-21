output "public_ip" {
  value = aws_lb.project_load_balancer.dns_name
  description = "This is the load balancer domain name"
}

