variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "cluster_name" {
  type    = string
  default = "thiru-tm-eks-cluster"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "node_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "node_desired_capacity" {
  type    = number
  default = 2
}

variable "create_ecr" {
  type    = bool
  default = true
}


# Use a map so you can set names and optionally additional properties later.
variable "ecr_repos" {
  type = map(string)
  default = {
    frontend = "tm-frontend-repo"
    backend  = "tm-backend-repo"
  }
  description = "Map of logical repo keys to repository names. e.g. { frontend = \"fe\", backend = \"be\" }"
}
