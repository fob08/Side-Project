
variable "db_remote_state_bucket" {
description = "The name of the S3 bucket for the database's remote state"
type = string
}
variable "db_remote_state_key" {
description = "The path for the database's remote state in S3"
type = string
}

variable "database" {
  type = object({
    allocated_storage = number
    storage_type = string
    engine = string
    engine_version = number
    instance_class = string
  })
}

#User login details
variable "db_login" {
  description = "This is the database username"
  type = object({
    username = string
    password = string 
    sensitive = true
  })
}

variable "role_name" {
  description = "The name of the IAM role"
  type = string
}

variable "service_principal" {
  description = "The service principal for which to grant permissions"
  type = string
}
