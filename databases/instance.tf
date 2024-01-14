resource "aws_db_instance" "mysql" {
  # vpc_security_group_ids = []
  identifier = "${var.cluster_name}-terraform"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.mysql.name

  backup_retention_period = var.backup_retention_period

  # 渡された値がある場合は、このインスタンスはレプリカになる。
  replicate_source_db = var.replicate_source_db

  # レプリカの場合は以下のパラメータは設定しないようにする。
  engine =  var.replicate_source_db == null ? "mysql" : null
  db_name = var.replicate_source_db == null ? "mydb" : null
  username = var.replicate_source_db == null ? local.db_creds.db_username : null
  password = var.replicate_source_db == null ? local.db_creds.db_password : null
}

resource "aws_db_subnet_group" "mysql" {
  name = "${var.cluster_name}-mysql-subnet-group"
  subnet_ids = data.terraform_remote_state.globals.outputs.subnet_ids
  
  tags = {
    "Name" = "${var.cluster_name}-mysql-subnet-group"
  }
}


data "aws_secretsmanager_secret_version" "db_creds" {
  secret_id = var.secret_name
}
locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)
}