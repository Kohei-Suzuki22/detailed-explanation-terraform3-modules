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
  default = null
  sensitive = true
}

variable "db_password" {
  description = "The password for the database"
  type = string
  default = null
  sensitive = true
}

variable "secret_name" {
  description = "The secret name which manage the db instance db_username and db_userpassword"
  default = null
  type = string
}

variable "backup_retention_period" {
  type = number
  default = 0
}

variable "replicate_source_db" {
  type = string
  default = null
}