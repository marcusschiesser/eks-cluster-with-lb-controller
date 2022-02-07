# EKS Cluster with Load Balancing Controller

This [terraform](https://www.terraform.io/) script creates a new EKS cluster in an existing VPC using spot instances with the following features:

1. [AWS Load Balancer Controller](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html) v2.3.1
2. [External DNS](https://github.com/kubernetes-sigs/external-dns) v0.10.2

The advantage of this configuration is that for the lifecycle of application specific resources (DNS entries, load balancers, target groups), Terraform is not needed. [Kubernetes ingress resources](https://kubernetes.io/docs/concepts/services-networking/ingress/) with [specific annotations](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/ingress/annotations/) are sufficient and can be checked into each application's repository to fulfill IaC requirements.

If certificates are added to the [AWS Certificate Manager](https://aws.amazon.com/certificate-manager/) in the cluster's account, the applications will be able to use the certificates as well. The certificates are discovered using [Certificate Discovery](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/ingress/cert_discovery/#discover-via-ingress-rule-host). This works with wildcard certificates as well.

[k8s/game2048.yaml](./k8s/game2048.yaml) is the [2048 game example](https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html) used by the AWS Load Balancer Controller, but this version is configured to use HTTP and HTTPS. 

This configuration doesn't create a VPC, but if needed one can easily be added by using the [VPC Terraform module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest).

> Note: This setup is loosely based on [Provisioning Kubernetes clusters on AWS with Terraform and EKS](https://learnk8s.io/terraform-eks#three-popular-options-to-provision-an-eks-cluster), but is using the latest software versions from 2022 and supports External DNS as well.