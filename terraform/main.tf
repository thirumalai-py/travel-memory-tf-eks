#################################
# VPC (terraform-aws-modules/vpc)
#################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

data "aws_availability_zones" "available" {}

#########################
# EKS cluster (module)
#########################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.0.0" # pin to a stable version

  cluster_name    = var.cluster_name
  cluster_version = "1.28" # choose supported Kubernetes version
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  # Control plane logging
  cluster_enabled_log_types = ["api", "audit", "authenticator"]

  # Enable OIDC and IRSA
  # Note: manage_aws_auth is intentionally not used here for module v20+
  # If you want Terraform-managed aws-auth, add the aws-auth submodule (see docs).
  # manage_aws_auth = true
  enable_irsa     = true

  node_groups = {
    default = {
      desired_capacity = var.node_desired_capacity
      max_capacity     = var.node_desired_capacity + 1
      min_capacity     = 1

      instance_types = [var.node_instance_type]
      key_name       = "" # optional: EC2 keypair name
      disk_size      = 50

      # recommended: use latest AMI type and EKS optimized AMI (default)
      ami_type = "AL2_x86_64"

      tags = {
        Name = "${var.cluster_name}-node"
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

#################
# ECR repositories (frontend & backend)
#################
# Create ECR repos for each item in var.ecr_repos
resource "aws_ecr_repository" "repos" {
  # conditional for_each; results in zero resources if create_ecr is false
  for_each = var.create_ecr ? var.ecr_repos : {}

  name                 = each.value
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
    component   = each.key
  }
}
