terraform {
  required_version = ">=1.0.1, <2.0.0"
  required_providers {
    aws = {
        source = "hashicorp/aws"
    version = "~> 4.0"
    }

  }
}

#This determine the region in which the application will be hosted
provider "aws" {
  region = "eu-central-1"
}

# This helps in creating an instance on aws 
resource "aws_instance" "project1" {
  ami = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.project_security.id] #This is needed so that the EC2 can know wich security group to utilize

#This is loaded when the EC2 instance is started
  user_data = <<-EOF
  #!/bin/bash
  echo "Hello, World" > index.html
  nohup busybox httpd -f -p ${var.server_port} &
  EOF

  tags = {
    Name = "project_instance"
  }
}

#This creates the security group because without it, no traffic will flow in or out of the EC2 instance.
resource "aws_security_group" "project_security" {
  name = "project_security_group"

  ingress = {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#this is needed to help specify how the autoscaling group will work
resource "aws_launch_configuration" "project_launch_config" {
    image_id = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.project_security.id] #This is needed so that the EC2 can know wich security group to utilize

#This is loaded when the EC2 instance is started
    user_data = <<-EOF
    #!/bin/bash
    echo "Hello, World" > index.html
    nohup busybox httpd -f -p ${var.server_port} &
    EOF

  #This is required when using a launch configuration with an autoscaling group
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "project_autoscaling" {
  launch_configuration = aws_launch_configuration.project_launch_config.name
  vpc_zone_identifier = data.aws_subnet.project_subnet.id
  min_size = var.min_size
  max_size = var.max_size

  tag {
    key = "Name"
    value = "Project_asg"
    propagate_at_launch = true
  }


}

#Multiple subnet ensures that the app keeps running if some datacenters have outages
data "aws_vpc" "project_vpc" {
  default = true
}

data "aws_subnet" "project_subnet" {
  filter {
    name = "vpc_id"
    values = [data.aws_vpc.project_vpc.default.id]
  }
}

#Application load balancer creation
resource "aws_lb" "project_load_balancer" {
  name = "project_lb"
  load_balancer_type = "application"
  subnets = data.aws_subnet.project_subnet.id
}

#for every load balancer, there is a need for a listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.project_load_balancer.arn
  port = var.lb_port
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



# creating RDS database instance
resource "aws_db_instance" "default" {
  allocated_storage = 10
  engine = "mysql"
  instance_class = "db.t3.micro"
  username = "sideproject"
  password = "sideproject"

  vpc_security_group_ids = [aws_security_group.project_security]
  db_subnet_group_name = aws_subnet.project_subnet.name


  skip_final_snapshot = true // required to destroy
}