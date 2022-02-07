module "external_dns_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.11.0"
  create_role                   = true
  role_name                     = "external-dns"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.external_dns.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:external-dns"]
}

resource "aws_iam_policy" "external_dns" {
  name_prefix = "external-dns"
  description = "EKS external-dns policy for cluster ${var.cluster_name}"
  policy      = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOT
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  chart      = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  # this is app version 0.10.2
  version   = "6.1.3"
  namespace = "kube-system"

  values = [<<EOF
    aws:
      region: ${var.aws_region}
    serviceAccount:
      name: ${module.external_dns_role.iam_role_name}
      annotations:
        eks.amazonaws.com/role-arn: "${module.external_dns_role.iam_role_arn}"
    # prevents ExternalDNS from deleting any records, omit to enable full synchronization    
    policy: upsert-only
    sources:
      - ingress
  EOF
  ]

}
