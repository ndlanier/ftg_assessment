resource "aws_ecs_cluster" "main_cluster" {
  name = "sonny_cluster"
}

resource "aws_ecs_task_definition" "ECS-ResumeApp-Task" {
  family = "Resume_Task"
  container_definitions = jsonencode(
    [
      {
        "name": "${var.app_name}-container",
        "image": "476540849243.dkr.ecr.us-east-2.amazonaws.com/demo-repo:latest",
        "memory": 400,
        "cpu": 1,
        "essential": true,
        "entryPoint": ["/"],
        execution_role_arn = "${aws_iam_instance_profile.ecs_agent.arn}",
        "portMappings": [
          {
            "containerPort": 3000,
            "hostPort": 8888
          }
        ]
      }
    ]
  )
  requires_compatibilities    = ["EC2"]
}

data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.ECS-ResumeApp-Task.family
}

resource "aws_ecs_service" "ECS-ResumeApp-Service" {
  name = "Resume_Service"
  cluster = aws_ecs_cluster.main_cluster.id
  task_definition = "${aws_ecs_task_definition.ECS-ResumeApp-Task.family}:${max(aws_ecs_task_definition.ECS-ResumeApp-Task.revision, data.aws_ecs_task_definition.main.revision)}"
  launch_type = "EC2"
  scheduling_strategy = "REPLICA"
  desired_count = 2
  force_new_deployment = true

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name = "${var.app_name}-container"
    container_port = 3000
  }

  depends_on = [aws_lb_listener.listener]
}

resource "aws_alb" "application_load_balancer" {
  name               = "${var.app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.load_balancer_security_group.id]

  tags = {
    Name        = "${var.app_name}-alb"
  }
}

resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = var.default_vpc

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "${var.app_name}-sg"
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.app_name}-tg"
  port        = 8888
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.default_vpc

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/v1/status"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.app_name}-lb-tg"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}