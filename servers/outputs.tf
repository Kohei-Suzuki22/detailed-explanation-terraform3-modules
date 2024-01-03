output "autoscaling_group_name" {
  value = aws_autoscaling_group.web-server.name 
}

output "alb_dns_name" {
  value = aws_lb.web-server.dns_name
}

output "web-server-sg-id" {
  value = aws_security_group.web-server.id
}

output "alb-sg-id" {
  value = aws_security_group.alb.id
}