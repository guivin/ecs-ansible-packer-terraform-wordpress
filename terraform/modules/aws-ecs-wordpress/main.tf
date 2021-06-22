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

  ingress {
	protocol    = "tcp"
	from_port   = var.wordpress_port
	to_port     = var.wordpress_port
	cidr_blocks = [
	  "0.0.0.0/0"]
  }

  egress {
	protocol    = "-1"
	from_port   = 0
	to_port     = 0
	cidr_blocks = [
	  "0.0.0.0/0"]
  }

  tags = merge({
	name = local.name
  }, var.tags)
}

resource "random_string" "wordpress_admin_password" {
  length = 16
}

resource "aws_ecs_task_definition" "task" {
  family                   = "wordpress"
  network_mode             = "awsvpc"
  requires_compatibilities = [
	"FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
	{
	  name             = local.name
	  essential        = true
	  image            = "${var.repository_url}:${var.image_tag}"
	  environment      = [
		{
		  name  = "WP_DB_WAIT_TIME"
		  value = "1"
		},
		{
		  name  = "WP_VERSION"
		  value = var.wordpress_version
		},
		{
		  name  = "TZ"
		  value = var.wordpress_timezone
		},
		{
		  name  = "WP_DB_HOST"
		  value = var.wordpress_db_host
		},
		{
		  name  = "WP_DB_NAME"
		  value = var.wordpress_db_name
		},
		{
		  name  = "WP_DB_USER"
		  value = var.wordpress_db_user
		},
		{
		  name  = "MYSQL_ENV_MYSQL_PASSWORD"
		  value = var.wordpress_db_password
		},
		{
		  name  = "WP_DOMAIN"
		  value = var.wordpress_domain
		},
		{
		  name  = "WP_URL"
		  value = var.wordpress_url
		},
		{
		  name  = "WP_LOCALE",
		  value = var.wordpress_locale
		},
		{
		  name  = "WP_SITE_TITLE"
		  value = var.wordpress_site_title
		},
		{
		  name  = "WP_ADMIN_USER"
		  value = var.wordpress_admin_user
		},
		{
		  name  = "WP_ADMIN_PASSWORD"
		  value = random_string.wordpress_admin_password.result
		},
		{
		  name  = "WP_ADMIN_EMAIL"
		  value = var.wordpress_admin_email
		}
	  ],
	  logConfiguration = {
		logDriver = "awslogs"
		options   = {
		  awslogs-group         = var.cloudwatch_log_group_name
		  awslogs-region        = var.region
		  awslogs-stream-prefix = "ecs"
		}
	  },
	  portMappings     = [
		{
		  hostPort      = var.wordpress_port
		  containerPort = var.wordpress_port
		  protocol      = "TCP"
		}
	  ]
	}
  ])

  tags = merge({
	name = local.name
  }, var.tags)
}

resource "aws_ecs_service" "default" {
  name            = local.name
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
	security_groups  = [
	  var.sg_id,
	  aws_security_group.ecs_tasks.id]
	subnets          = [
	  var.subnet_id]
	assign_public_ip = true
  }

  tags = merge({
	name = local.name
  }, var.tags)
}
