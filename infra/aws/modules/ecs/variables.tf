variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "alb_dns_name" {
  type = string
}

variable "alb_security_group_id" {
  type = string
}

variable "backend_target_group_arn" {
  type = string
}

variable "frontend_target_group_arn" {
  type = string
}

variable "backend_image" {
  type = string
}

variable "frontend_image" {
  type = string
}
variable "desired_count" {
  type    = number
  default = 1
}

variable "enable_autoscaling" {
  type    = bool
  default = false
}

variable "autoscaling_max_capacity" {
  type    = number
  default = 1
}
