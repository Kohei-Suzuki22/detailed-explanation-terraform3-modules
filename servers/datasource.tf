data "terraform_remote_state" "globals" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    # key = "globals/terraform.tfstate"
    key = var.globals_remote_state_key
    region = "ap-northeast-1"
  }  
}

data "terraform_remote_state" "databases" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key = var.databases_remote_state_key
    region = "ap-northeast-1"
  }   
}