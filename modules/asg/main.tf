
resource "aws_security_group" "app_sg" {
    name = "tf-app-sg"
    description = "Allow traffic from ALB"
    vpc_id = var.vpc_id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [var.alb_sg_id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"]

    filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_launch_template" "app_lt" {
    name_prefix = "tf-app-"
    image_id = data.aws_ami.amazon_linux.id
    instance_type = "t2.micro"

    vpc_security_group_ids = [aws_security_group.app_sg.id]
    user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install -y nginx1
    systemctl enable nginx
    systemctl start nginx
    echo "Hello from Terraform $(hostname)" > /usr/share/nginx/html/index.html
    EOF
    )
}



resource "aws_autoscaling_group" "asg" {
    desired_capacity = 2
    max_size = 3
    min_size = 2

    vpc_zone_identifier = var.private_subnets


    launch_template {
        id = aws_launch_template.app_lt.id
        version = "$Latest"
    }
    target_group_arns = [var.target_group_arn]
}