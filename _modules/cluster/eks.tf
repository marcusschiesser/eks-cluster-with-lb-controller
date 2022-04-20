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
  version = "18.20.2"

  cluster_name    = var.cluster_name
  cluster_version = "1.21"

  subnet_ids  = var.private_subnets
  vpc_id      = var.vpc_id
  enable_irsa = true

  eks_managed_node_groups = {
    workers = {
      min_size     = 2
      max_size     = 5
      desired_size = 2

      instance_types = var.instance_types
    }
  }

  node_security_group_additional_rules = {
    # This is needed for webhooks called by the Kube API, e.g. the LB controller is using a MutatingAdmissionWebhook
    ingress_cluster_all = {
      description                   = "Allow workers pods to receive communication from the cluster control plane."
      protocol                      = "TCP"
      from_port                     = 1025
      to_port                       = 65535
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }
}
