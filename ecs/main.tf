resource "aws_ecs_cluster" "cluster" {
  name = "Cluster"
  setting {
    name = "containerInsights"
    value = "enabled"
  }
  tags = {
    Name = "${var.name}-ecs-cluster-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "task" {
  family = "service"
  network_mode = "awsvpc"
  requires_compatibilities = [ "FARGATE", "EC2" ]
  cpu = 512
  memory = 1024
  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:1.23.1"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name = "service"
  cluster = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.id
  desired_count = 1
  launch_type = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    assign_public_ip = true
    security_groups = [var.sec_group_id]
    subnets = [var.public_subnet_id]
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}