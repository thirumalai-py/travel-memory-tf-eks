aws_region = "us-west-2"
cluster_name = "demo-eks-cluster"

create_ecr = true

ecr_repos = {
  frontend = "company-frontend"
  backend  = "company-backend"
}
