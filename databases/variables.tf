variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type = string
}

variable "remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type = string
}

variable "globals_remote_state_key" {
  description = "The path for the globals remote state in S3"
  type = string
  
}

variable "db_username" {
  description = "The username for the database"
  type = string
  sensitive = true
}

variable "db_password" {
  description = "The password for the database"
  type = string
  sensitive = true
}