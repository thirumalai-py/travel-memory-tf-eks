output "cluster_name" {
  value = module.eks.cluster_id
}

output "kubeconfig_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
  sensitive = false
}

output "kubeconfig_endpoint" {
  value = module.eks.cluster_endpoint
}

output "kubeconfig" {
  value = module.eks.kubeconfig
  description = "Kubeconfig (base64 encoded) - consider using aws eks update-kubeconfig instead."
  sensitive = true
}

output "ecr_repository_urls" {
  value = var.create_ecr ? {
    for k, v in aws_ecr_repository.repos : k => v.repository_url
  } : {}
  description = "Map of logical repo key -> repository URL (frontend/backend)."
}

