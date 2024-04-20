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