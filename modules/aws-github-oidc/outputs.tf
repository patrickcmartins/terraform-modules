output "provider_arn" {
  description = "ARN do OIDC provider do GitHub."
  value       = local.provider_arn
}

output "role_arns" {
  description = "Mapa nome -> ARN das roles criadas."
  value       = { for k, r in aws_iam_role.this : k => r.arn }
}
