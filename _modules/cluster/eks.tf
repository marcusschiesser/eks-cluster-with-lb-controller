data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.21"

  subnets     = var.private_subnets
  vpc_id      = var.vpc_id
  enable_irsa = true

  workers_additional_policies = [aws_iam_policy.worker_policy.arn]
  worker_groups_launch_template = [{
    name                    = "worker-group"
    override_instance_types = ["m5.large", "m5a.large", "m4.large"]
    spot_instance_pools     = 4
    asg_max_size            = 5
    asg_desired_capacity    = 2
    kubelet_extra_args      = "--node-labels=node.kubernetes.io/lifecycle=spot"
  }]
}




