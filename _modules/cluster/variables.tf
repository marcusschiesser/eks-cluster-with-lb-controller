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

variable "eks_managed_node_groups" {
  description = "Map of EKS managed node group definitions to create"
  type        = any
  default     = {}
}

variable "enable_efs" {
  # if true, needs to add a K8S StorageClass, see https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html#efs-sample-app
  description = "If true, creates an EFS based storage to support ReadWriteMany volume claims"
  default     = false
  type        = bool
}
