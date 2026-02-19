variable "service_name" {}
variable "image" {}
variable "region" {}
variable "port" {}
variable "backend_url" {
  type    = string
  default = null
}
variable "min_instances" {
  type    = number
  default = 0
}

variable "max_instances" {
  type    = number
  default = 1
}
variable "memory" {
  type    = string
  default = "512Mi"
}
