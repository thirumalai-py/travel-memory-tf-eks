aws_region = "ap-south-1"
cluster_name = "thiru-eks-cluster"

create_ecr = true

ecr_repos = {
  frontend = "tm-frontend"
  backend  = "tm-backend"
}
