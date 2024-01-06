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

variable "databases_remote_state_key" {
  description = "The path for the database's remote state in S3"
  type = string
}


variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

variable "instance_type" {
  description = "The type of EC2 instances to run (e.g. t2.micro)"
  type = string
  default = "t2.micro"
}

variable "autoscaling_min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type = number
  default = 2
}

variable "autoscaling_max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type = number
  default = 2
}

variable "custom_tags" {
  type = map(string)

  default = {
    "Owner" = "team-foo"
    "DeployedBy" = "terraform"
  }
  
}