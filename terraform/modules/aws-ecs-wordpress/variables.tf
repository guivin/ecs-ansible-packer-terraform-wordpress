variable "region" {
  type = string
  description = "AWS region"
}

variable "wordpress_port" {
  type = number
  description = "(Required) TCP port for Wordpress"
}

variable "vpc_id" {
  type = string
  description = "(Required) The VPC ID authorized to access Wordpress ECS task"

}

variable "ecr_repository_url" {
  type = string
  description = "(Required) The ECR repository url where Wordpress image is persisted"
}

variable "docker_image" {
  type = string
  default = "(Required) The Docker image name of Wordpress to use"
}

variable "fargate_cpu" {
  type = number
  description = "(Optional) Number of cpu units used by the task"
}

variable "fargate_memory" {
  type = number
  default = "(Optional) Amount (in MiB) of memory used by the task"
}

variable "subnets" {
  type = list(string)
  default = "(Required) Subnets associated with the task or service"
}

variable "task_desired_count" {
  type = number
  description = "(Optional) Number of instances of the task definition to place and keep running. Defaults to 0"
}

variable "ecs_cluster_id" {
  type = string
  description = "(Required) The ECS cluster ID where to deploy Wordpress"
}
