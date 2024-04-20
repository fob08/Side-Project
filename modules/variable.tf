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