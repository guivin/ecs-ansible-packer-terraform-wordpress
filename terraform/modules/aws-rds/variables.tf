variable "region" {
  type        = string
  description = "(Required) AWS region to use"
}

variable "vpc_id" {
  type        = string
  description = "(Required) The VPC ID where to deploy RDS instance"
}

variable "allowed_security_groups" {
  type        = list(string)
  description = "(Optional) List of security groups authorized to connect to database port"
  default     = []
}

variable "availability_zone" {
  type        = string
  description = "(Required) Availability zone for the RDS instance"
}

variable "tags" {
  type        = map(string)
  description = "(Optional) Tags for resources"
}

variable "db_port" {
  type        = number
  description = "(Optional) TCP port for database to define for use"
  default     = 3306
}

variable "db_allocated_storage" {
  type        = number
  description = "(Required) The allocated storage in gibibytes"
}

variable "db_name" {
  type        = string
  description = "(Optional) The name of the database to create when the DB instance is created"
}

variable "db_instance_class" {
  type        = string
  description = "(Required) The instance type of the RDS instance"
}

variable "db_storage_type" {
  type        = string
  description = "(Optional) One of standard (magnetic), gp2 (general purpose SSD), or io1 (provisioned IOPS SSD)"
}

variable "db_username" {
  type        = string
  description = "(Required) Username for the master DB user"
}

variable "db_engine" {
  type        = string
  description = "(Required) The database engine to use"
}

variable "db_engine_version" {
  type        = string
  description = "(Optional) The engine version to use (https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html)"
}

variable "db_parameter_group_name" {
  type        = string
  description = "(Optional) Name of the DB parameter group to associate"
}

variable "db_skip_final_snapshot" {
  type        = bool
  description = "(Optional) Determines whether a final DB snapshot is created before the DB instance is deleted"
}
