resource "aws_ecs_cluster" "main" {
    name = "hado-cluster"
}

resource "aws_ecs_task_definition" "app" {
    family                   = "hado-app-task"
    execution_role_arn       = aws_iam_role.ecs_execution_role.arn
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = var.fargate_cpu
    memory                   = var.fargate_memory
    container_definitions    =  jsonencode([
    {
      name = "app"
      image = var.app_image
      memory                  = 1024
      memory_reservation      = 1024
      portMappings = [
        {
          containerPort = var.app_port
          hostPort = 3000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "main" {
    name            = "hado-service"
    cluster         = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.app.arn
    desired_count   = 1
    launch_type     = "FARGATE"

    network_configuration {
        security_groups = [aws_security_group.app_task.id]
        subnets          = [aws_subnet.public_subnet.id]
        assign_public_ip = true
    }


}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_task_execution_role"
 
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
        "Effect": "Allow",
        "Principal": {
         "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }    
  ]
}
EOF
}

resource "aws_iam_policy" "ecs_permissions" {
  name        = "my_ecs_permissions"
  description = "Permissions to enable CT"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecs:StartTask",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }    
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "ecs_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecs_permissions.arn
}

resource "aws_security_group" "app_task" {
  name        = "app-task-security-group"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = 3000
    to_port         = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}