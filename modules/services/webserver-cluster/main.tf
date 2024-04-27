# This helps in creating an instance on aws 

#This creates the security group because without it, no traffic will flow in or out of the EC2 instance.
resource "aws_security_group" "project_security" {
  name = "${var.cluster_name}-project_security_group"
}

#this is needed to help specify how the autoscaling group will work
resource "aws_launch_configuration" "project_launch_config" {
    image_id = "ami-0fb653ca2d3203ac1"
    instance_type = var.instance_type
    security_groups = [aws_security_group.project_security.id] #This is needed so that the EC2 can know wich security group to utilize
  # Render the User Data script as a template
    user_data = templatefile("${path.module}/user-data.sh", {
    server_port = var.server_port
    db_address = data.terraform_remote_state.db.outputs.address
    db_port = data.terraform_remote_state.db.outputs.port
})
  #This is required when using a launch configuration with an autoscaling group
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "project_autoscaling" {
  launch_configuration = aws_launch_configuration.project_launch_config.name
  vpc_zone_identifier = data.aws_subnets.project_subnet.ids
  target_group_arns = [aws_lb_target_group.project_target_group.arn]
  health_check_type = "ELB"

  min_size = var.min_size
  max_size = var.max_size

  tag {
    key = "Name"
    value = var.cluster_name
    propagate_at_launch = true
  }


}

#Multiple subnet ensures that the app keeps running if some datacenters have outages
data "aws_vpc" "project_vpc" {
  default = true
}

data "aws_subnets" "project_subnet" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.project_vpc.id]
  }
}

#Application load balancer creation
resource "aws_lb" "project_load_balancer" {
  name = "${var.cluster_name}-project-lb"
  load_balancer_type = "application"
  subnets = data.aws_subnets.project_subnet.ids
  security_groups = [aws_security_group.alb_security_group.id]
}

#for every load balancer, there is a need for a listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.project_load_balancer.arn
  port = local.http_port
  protocol = "HTTP"

  #This returns a 404 error page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: The page you are trying to access could not be found."
      status_code = 404
    }
  }

}

resource "aws_security_group" "alb_security_group" {
  name = "${var.cluster_name}-project_alb_security_group"
}
resource "aws_security_group_rule" "allow_http_inbound" {
  type = "ingress"
  security_group_id = aws_security_group.alb_security_group.id
  from_port = local.http_port
  to_port = local.http_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
  }

  #this resource define the outbond rule
resource "aws_security_group_rule" "allow_all_outbound" {
  type = "egress"
  security_group_id = aws_security_group.alb_security_group.id
  from_port = local.any_port
  to_port = local.any_port
  protocol = local.any_protocol
  cidr_blocks = local.all_ips
  }
resource "aws_lb_target_group" "project_target_group" {
  name = "${var.cluster_name}-project-target-group"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.project_vpc.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

#This add a listener rule that send request which match any path to the target group that contains the ASG
resource "aws_lb_listener_rule" "project_lb_listener" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.project_target_group.arn
  }
}

#This allows the app to read state file from the same s3 bucket and folder where the database stores its state
data "terraform_remote_state" "db" {
backend = "s3"
config = {
bucket = var.db_remote_state_bucket
key = var.db_remote_state_key
region = "eu-central-1"
}
}

