variable "user_name" {
  type = string  
}

resource "aws_iam_user" "module_example" {
  name = var.user_name
}

