resource "aws_ecs_cluster" "final-cluster" {
  name = "final-cluster"

  tags = {
    Name = "final-cluster"
  }
}

resource "aws_ecs_service" "final-service-backend" {
  name                               = "final-service-backend"
  cluster                            = aws_ecs_cluster.final-cluster.id
  launch_type                        = "FARGATE"
  enable_execute_command             = true
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 1
  task_definition                    = aws_ecs_task_definition.final-task-definition-backend.id

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "final-backend-container"
    container_port   = 3004
  }

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.final_sg.id]
    subnets          = [aws_subnet.sn1.id, aws_subnet.sn2.id]
  }

  tags = {
    Name = "final-service-backend"
  }
}

resource "aws_ecs_task_definition" "final-task-definition-backend" {
  container_definitions = jsonencode([
    {
      name : "final-backend-container",
      image : "${aws_ecr_repository.final-repo.repository_url}",
      essential : true,
      portMappings : [
        {
          containerPort : 3004,
          hostPort : 3004,
          protocol : "tcp"
        }
      ]
      environment = [
        {
          name : "SUPABASE_URL",
          value : "${var.supabase_url}"
        },
        {
          name : "SUPABASE_KEY",
          value : "${var.supabase_key}"
        }
      ]
    }
  ])


  family                   = "final-task-definition-backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
}

resource "aws_ecs_service" "final-service-frontend" {
  name                               = "final-service-frontend"
  cluster                            = aws_ecs_cluster.final-cluster.id
  launch_type                        = "FARGATE"
  enable_execute_command             = true
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 1
  task_definition                    = aws_ecs_task_definition.final-task-definition-frontend.id

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.final_sg.id]
    subnets          = [aws_subnet.sn1.id, aws_subnet.sn2.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_tg.arn
    container_name   = "final-frontend-container"
    container_port   = 8080
  }

  tags = {
    Name = "final-service-frontend"
  }
}

resource "aws_ecs_task_definition" "final-task-definition-frontend" {
  container_definitions = jsonencode([
    {
      name : "final-frontend-container",
      image : "${aws_ecr_repository.final-repo.repository_url}",
      essential : true,
      portMappings : [
        {
          containerPort : 8080,
          hostPort : 8080,
          protocol : "tcp"
        }
      ]
    }
  ])


  family                   = "final-task-definition-frontend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}
