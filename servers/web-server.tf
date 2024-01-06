# resource "aws_instance" "web-server" {
#   ami = "ami-07c589821f2b353aa"
#   instance_type = "t2.micro"
#   subnet_id = data.terraform_remote_state.globals.outputs.subnet_ids[0]

#   associate_public_ip_address = true
#   availability_zone = "ap-northeast-1a"
# }


resource "aws_launch_configuration" "web-server" {
  image_id = "ami-07c589821f2b353aa"
  instance_type = var.instance_type


  security_groups = [aws_security_group.web-server.id]

  # templatefileで、module内のpathを参照する際は、${path.module}を使わないといけない。
  user_data = templatefile("${path.module}/scripts/user-data.sh", {
    server_port = var.server_port
    db_address = data.terraform_remote_state.databases.outputs.address
    db_port = data.terraform_remote_state.databases.outputs.port
  })
  
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "web-server" {
  launch_configuration = aws_launch_configuration.web-server.name
  vpc_zone_identifier = data.terraform_remote_state.globals.outputs.subnet_ids

  target_group_arns = [aws_lb_target_group.alb.arn]
  health_check_type = "ELB"

  min_size = var.autoscaling_min_size
  max_size = var.autoscaling_max_size

  instance_refresh {
    strategy = "Rolling"
  }

  dynamic "tag" {
    for_each = var.custom_tags

    content {
      key = each.key
      value = each.value
      propagate_at_launch = true
    }
  }

  tag {
    key = "Name"
    value = "${var.cluster_name}-terraform-web-server-asg"
    propagate_at_launch = true
  }
}


resource "aws_lb" "web-server" {
  name = "${var.cluster_name}-web-server-alb"
  load_balancer_type = "application"
  subnets = data.terraform_remote_state.globals.outputs.subnet_ids
  security_groups = [aws_security_group.alb.id]
}


resource "aws_lb_listener" "web-server" {
  load_balancer_arn = aws_lb.web-server.arn
  port = local.http_port
  protocol = "HTTP"

  default_action {
    type = "fixed-response"


    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
  }
  
}

resource "aws_lb_listener_rule" "alb" {
  listener_arn = aws_lb_listener.web-server.arn
  priority = 100
  
  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
}

resource "aws_lb_target_group" "alb" {
  name = "${var.cluster_name}-web-server-alb-target"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.terraform_remote_state.globals.outputs.terraform_vpc_id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
  
}