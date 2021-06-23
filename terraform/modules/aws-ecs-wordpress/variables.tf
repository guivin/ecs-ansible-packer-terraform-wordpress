variable "region" {
  type        = string
  description = "(Required) AWS region"
}

variable "tags" {
  type        = map(string)
  description = "(Required) Tags for resources"
}

variable "sg_id" {
  type        = string
  description = "(Required) Security group ID of the VPC"
}

variable "subnet_id" {
  type        = string
  description = "(Required) The subnet ID to use for the ECS service"
}

variable "vpc_id" {
  type        = string
  description = "(Required) The VPC ID for associating the dedicated wordpress security group"
}

variable "cloudwatch_log_group_name" {
  type        = string
  description = "(Required) The Cloudwatch log group name to store the container logs"
}

variable "wordpress_db_host" {
  type        = string
  description = "(Required) The database host to use for Wordpress"
}

variable "wordpress_db_name" {
  type        = string
  description = "(Required) The database name to use for Wordpress"
}

variable "wordpress_db_user" {
  type        = string
  description = "(Required) The database user to use for connection"
}

variable "wordpress_db_password" {
  type        = string
  description = "(Required) The database password to use for connection"
}

variable "wordpress_db_port" {
  type        = number
  description = "(Required) The database port to use for connection"
}

variable "wordpress_version" {
  type        = string
  description = "(Optional) The Wordpress version to use"
  default     = "5.4.2"
}

variable "wordpress_timezone" {
  type        = string
  description = "(Optional) The timezone to use for Wordpress"
  default     = "Europe/Paris"
}

variable "wordpress_domain" {
  type        = string
  description = "(Optional) The domain to use for Wordpress configuration"
  default     = "localhost"
}

variable "wordpress_url" {
  type        = string
  description = "(Optional) The URL to use for Wordpress configuration"
  default     = "http://localhost"
}

variable "wordpress_locale" {
  type        = string
  description = "(Optional) Locale to use for Wordpress configuration"
  default     = "en_US"
}

variable "wordpress_site_title" {
  type        = string
  description = "(Optional) Site title to use for Wordpress configuration"
  default     = "WordPress for development"
}

variable "wordpress_admin_user" {
  type        = string
  description = "(Optional) The Wordpress admin user"
  default     = "admin"
}

variable "wordpress_admin_email" {
  type        = string
  description = "The Wordpress admin email"
  default     = "admin@domain.com"
}

variable "wordpress_port" {
  type        = number
  description = "(Required) The TCP port exposed by Wordpress"
}

variable "repository_url" {
  type        = string
  description = "(Required) The ECR repository url where Wordpress image is persisted"
}

variable "image_tag" {
  type        = string
  description = "(Required) The image of Wordpress to use"
}

variable "desired_count" {
  type        = number
  description = "(Optional) Number of instances of the task definition to place and keep running. Defaults to 0"
  default     = 0
}

variable "fargate_cpu" {
  type        = number
  description = "(Optional) Number of cpu units used by the task"
}

variable "fargate_memory" {
  type        = number
  description = "(Optional) Amount (in MiB) of memory used by the task"
}

variable "ecs_cluster_id" {
  type        = string
  description = "(Required) The ECS cluster ID where to deploy Wordpress"
}
