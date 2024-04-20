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

variable "min_size" {
  type = number
  default = 2
}

variable "max_size" {
    type = number
    default = 10
}

variable "lb_port" {
  type = number
  default = 80
}

variable "region" {
  type = string
  description = "AWS region name to create and manage resources in"
#  default = "eu-central-1"
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
