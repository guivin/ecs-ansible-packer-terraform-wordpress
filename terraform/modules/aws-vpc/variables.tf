variable "region" {
  type        = string
  description = "AWS region"
}

variable "cidr_block" {
  type        = string
  description = "Cidr block assigned to the VPC"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable dns hostnames in the VPC"
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of cidr blocks for private subnets"
  default     = []
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of cidr blocks for public subnets"
  default     = []
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones for public and private subnets"
  default     = []
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map public ip on launc of instances"
  default     = false
}

variable "single_nat_gateway" {
  type        = bool
  description = "Enable or not single nat gateway for private subnets"
  default     = true
}
