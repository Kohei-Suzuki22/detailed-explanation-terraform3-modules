output "address" {
  description = "Connect to the database at this endpoint"
  value = aws_db_instance.mysql.address
}

output "port" {
  description = "The port the database is listhening on"
  value = aws_db_instance.mysql.port
}

output "db_instance_arn" {
  value = aws_db_instance.mysql.arn
}