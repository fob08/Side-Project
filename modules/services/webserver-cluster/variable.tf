variable "access_key" {
    description = "This is meant to store the access key used to access the aws platform"
    type = string
}

variable "secret_key" {
    description = "This is meant to store the access key used to access the aws platform"
    type = string
}

variable "server_port" {
    description = "This is the port the server will be utilizing"
    type = number
    default = 8080
}

locals {
  http_port = 80
  any_port = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips = ["0.0.0.0/0"]
}
variable "instance_type" {
  description = "The type of EC2 Instances to run"
  type = string
}
variable "min_size" {
  description = "The minimum number of Ec2 instance in the ASG"
  type = number
}

variable "max_size" {
  description = "The maximum number of Ec2 instance in the ASG"
    type = number
}

variable "region" {
  type = string
  description = "AWS region name to create and manage resources in"
  default = "eu-central-1"
}

variable "force_delete" {
  description = "If `true`, will delete the repository even if it contains images. Defaults to `false`"
  type        = bool
  default     = false
}
variable "ecr" {
  type = string
  description = "This is the name of the elastic container registry"

}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`."
  type        = string
  default     = "MUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "The image_tag_mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
  type        = bool
  default     = true
}

# Policy
variable "policy" {
  description = "Manages the ECR repository policy"
  type        = string
  default     = null
}

# Lifecycle policy
variable "lifecycle_policy" {
  description = "Manages the ECR repository lifecycle policy"
  type        = string
  default     = null
}

variable "lb_port" {
  description = "The port for the load balancer"
  type        = number
}

variable "cluster_name" {
description = "The name to use for all the cluster resources"
type = string
}

variable "db_remote_state_bucket" {
description = "The name of the S3 bucket for the database's remote state"
type = string
}
variable "db_remote_state_key" {
description = "The path for the database's remote state in S3"
type = string
}
