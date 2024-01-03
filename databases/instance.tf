resource "aws_db_instance" "mysql" {
  # vpc_security_group_ids = []
  identifier = "${var.cluster_name}-terraform"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  skip_final_snapshot = true
  db_name = "mydb"
  db_subnet_group_name = aws_db_subnet_group.mysql.name

  username = var.db_username
  password = var.db_password
}

resource "aws_db_subnet_group" "mysql" {
  name = "${var.cluster_name}-mysql-subnet-group"
  subnet_ids = data.terraform_remote_state.globals.outputs.subnet_ids
  
  tags = {
    "Name" = "${var.cluster_name}-mysql-subnet-group"
  }
}


