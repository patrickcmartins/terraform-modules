output "namespace" {
  description = "Namespace onde o Argo CD foi instalado."
  value       = helm_release.argocd.namespace
}

output "chart_version" {
  description = "Versão do chart instalada."
  value       = helm_release.argocd.version
}
