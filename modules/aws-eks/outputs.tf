output "cluster_name" {
  description = "Nome do cluster EKS."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint da API do EKS."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "CA do cluster em base64 (como a AWS devolve)."
  value       = module.eks.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  description = "ARN do OIDC provider do cluster (para IRSA)."
  value       = module.eks.oidc_provider_arn
}

output "vpc_id" {
  description = "ID da VPC."
  value       = module.vpc.vpc_id
}
