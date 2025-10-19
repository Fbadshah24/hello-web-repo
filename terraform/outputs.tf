output "kubeconfig_cluster_name" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_ca_certificate" {
  value = module.eks.cluster_certificate_authority_data
}

output "ecr_repo_uri" {
  value = aws_ecr_repository.hello_web.repository_url
}

output "cluster_name" {
  value = module.eks.cluster_name
}