variable "tags" {
  type = map(string)
  description = "(Required) Tags for resources"
}

variable "region" {
  type = string
  description = "(Required) AWS region"
}
