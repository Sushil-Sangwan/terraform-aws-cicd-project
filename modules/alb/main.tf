resource "aws_security_group" "alb_sg" {
    name = "tf-alb-sg"
    description = "Allow HTTP"
    vpc_id = var.vpc_id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_lb_target_group" "tg" {
    name = "tf-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id
    target_type = "ip"

    health_check {
      path = "/"
    }
}

resource "aws_lb" "alb" {
    name = "tf-alb"
    internal = false
    load_balancer_type = "application"

    subnets = var.public_subnets
    security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.tg.arn
    }
}