data "aws_iam_policy_document" "argowf_s3" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      #"s3:DeleteObject",
    ]
    resources = ["${aws_s3_bucket.argowf.arn}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = ["${aws_s3_bucket.argowf.arn}"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation"
    ]
    resources = ["arn:aws:s3:::*"]
  }
}

resource "aws_s3_bucket" "argowf" {
  force_destroy = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = local.name
  cluster_version = local.cluster_version

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.large"]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_accounts = [
    data.aws_caller_identity.current.account_id
  ]
}

module "irsa_argo_wf" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                          = "${local.name}-argo_wf"
  allow_self_assume_role = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "argo-workflows:argo-workflows-server",
        "argo-workflows:argo-workflows-workflow-controller",
        "argo-workflows:executor",
        "argo-workflows:admin",
      ]
    }
  }
  role_policy_arns = {
    s3 = aws_iam_policy.argowf_s3.arn
  }
}

resource "aws_iam_policy" "argowf_s3" {
  name   = "${local.name}-argowf-s3"
  path   = "/"
  policy = data.aws_iam_policy_document.argowf_s3.json
}
