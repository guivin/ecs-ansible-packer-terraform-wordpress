variable "region" {
  type        = string
  description = "(Required) AWS region"
}

variable "tags" {
  type        = map(string)
  description = "(Required) Tags for resources"
}

variable "availability_zone" {
  type = string
  description = "(Required) The subnet of the availability zone to use"
}
