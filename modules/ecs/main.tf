resource "aws_ecs_cluster" "cluster" {
    name = "tf-ecs-cluster"
}

resource "aws_ecs_task_definition" "task" {
    family = "tf-nginx-task"
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    cpu = "256"
    memory = "512"


    container_definitions = jsonencode([
        {
            name = "nginx"
            image = var.image
            portMappings = [
                {
                    containerPort = 80
                    hostPort = 80
                }
            ]
        }
    ])
  
}

resource "aws_security_group" "ecs_sg" {
  name   = "tf-ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "service" {
  name            = "tf-ecs-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "nginx"
    container_port   = 80
  }

  depends_on = [var.target_group_arn]
}