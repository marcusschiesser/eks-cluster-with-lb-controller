variable "cluster_name" {
  type    = string
  default = "my-cluster"
}

variable "aws_account_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "aws_region" {
  type = string
}
 
