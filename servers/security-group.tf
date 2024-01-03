resource "aws_security_group" "web-server" {
  name = "${var.cluster_name}-web-server"
  vpc_id = data.terraform_remote_state.globals.outputs.terraform_vpc_id
  tags = {
    "Name" : "${var.cluster_name}-web-server"
  }
}


resource "aws_security_group_rule" "web-server-ingress" {
  security_group_id = aws_security_group.web-server.id
  type = "ingress"

  from_port = var.server_port
  to_port = var.server_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}


resource "aws_security_group_rule" "web-server-egress" {
  security_group_id = aws_security_group.web-server.id
  type = "egress"

  from_port = local.any_port
  to_port = local.any_port
  protocol = local.any_protocol
  cidr_blocks = local.all_ips
}


resource "aws_security_group" "alb" {
  name = "${var.cluster_name}-alb"
  vpc_id = data.terraform_remote_state.globals.outputs.terraform_vpc_id
  tags = {
    "Name" : "${var.cluster_name}-alb"
  }
}


resource "aws_security_group_rule" "alb-ingress" {
  security_group_id = aws_security_group.alb.id
  type = "ingress"

  from_port = local.http_port
  to_port = local.http_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips

}

resource "aws_security_group_rule" "alb-egress" {
  security_group_id = aws_security_group.alb.id
  type = "egress"

  from_port = local.any_port
  to_port = local.any_port
  protocol = local.any_protocol
  cidr_blocks = local.all_ips
}