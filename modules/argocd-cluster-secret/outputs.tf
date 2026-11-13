output "secret_name" {
  description = "Nome do Secret de cluster criado no hub."
  value       = kubernetes_secret_v1.this.metadata[0].name
}

output "cluster_name" {
  description = "Nome do cluster no Argo CD."
  value       = var.name
}
