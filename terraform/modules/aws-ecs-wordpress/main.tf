resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-execution-role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
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

resource "aws_iam_policy" "ecs_task_execution_policy" {
  name = "ecs-execution-policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Action": [
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

# Attach execution policy to execution role
resource "aws_iam_role_policy_attachment" "ecs_role_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
}


resource "aws_security_group" "ecs_tasks" {
  name        = "wordpress-ecs-sg"
  description = "Allow inbound access in port 80 only"
  vpc_id      = var.vpc_id
}


ingress {
  protocol        = "tcp"
  from_port       = var.wordpress_port
  to_port         = var.wordpress_port
  cidr_blocks     = ["0.0.0.0/0"]
}

egress {
  protocol    = "-1"
  from_port   = 0
  to_port     = 0
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_ecs_task_definition" "task" {
  family                   = "wordpress"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = <<DEFINITION
[
  {
    "cpu": var.fargate_cpu,
    "image": "${var.ecr_repository_url}:${var.docker_image}",
    "memory": var.fargate_memory,
    "name": "app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": var.app_port,
        "hostPort": var.app_port
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "default" {
  name            = "wordpress-ecs-service"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
	security_groups  = [aws_security_group.ecs_tasks.id]
	subnets          = [var.subnets]
	assign_public_ip = true
  }
}
