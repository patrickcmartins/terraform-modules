output "name" {
  description = "Nome do cluster."
  value       = kind_cluster.this.name
}

output "endpoint" {
  description = "API server visto do HOST (https://127.0.0.1:<porta>)."
  value       = kind_cluster.this.endpoint
}

output "internal_endpoint" {
  description = "API server visto de OUTRO cluster kind (rede docker 'kind'). Use para registrar no Argo CD hub."
  value       = "https://${var.name}-control-plane:6443"
}

output "cluster_ca_certificate" {
  description = "CA do cluster (PEM)."
  value       = kind_cluster.this.cluster_ca_certificate
}

output "client_certificate" {
  description = "Certificado de cliente admin (PEM)."
  value       = kind_cluster.this.client_certificate
  sensitive   = true
}

output "client_key" {
  description = "Chave do cliente admin (PEM)."
  value       = kind_cluster.this.client_key
  sensitive   = true
}
