output "public_ip" {
  value = aws_lb.project_load_balancer.dns_name
  description = "This is the load balancer domain name"
}

output "ASG" {
  value = aws_autoscaling_group.project_autoscaling.name
  description = "The name of the Auto Scaling Group"
}

output "alb_dns_name" {
value = aws_lb.project_load_balancer.dns_name
description = "The domain name of the load balancer"
}

output "alb_security_group_id" {
value = aws_security_group.alb_security_group.id
description = "The ID of the Security Group attached to the load balancer"
}