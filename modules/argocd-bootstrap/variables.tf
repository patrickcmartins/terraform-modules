variable "namespace" {
  description = "Namespace do Argo CD."
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Versão do chart argo/argo-cd."
  type        = string
  default     = "10.18.0"
}

variable "apps_chart_version" {
  description = "Versão do chart argo/argocd-apps (usado para criar a root app)."
  type        = string
  default     = "2.0.8"
}

variable "values" {
  description = "Lista de values YAML extras para o chart do Argo CD (mesclados após os defaults do módulo)."
  type        = list(string)
  default     = []
}

variable "root_app" {
  description = "A única Application criada pelo Terraform. Daqui pra frente, tudo é GitOps."
  type = object({
    name     = optional(string, "root")
    repo_url = string
    revision = optional(string, "main")
    path     = string
  })
}
