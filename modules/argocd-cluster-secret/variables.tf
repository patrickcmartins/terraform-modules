variable "name" {
  description = "Nome do cluster como o Argo CD vai enxergar (destination.name)."
  type        = string
}

variable "server" {
  description = "URL do API server alcançável a partir dos pods do Argo CD."
  type        = string
}

variable "namespace" {
  description = "Namespace do Argo CD no hub."
  type        = string
  default     = "argocd"
}

variable "ca_data" {
  description = "CA do cluster em PEM (o módulo faz o base64)."
  type        = string
}

variable "client_certificate" {
  description = "Auth por certificado de cliente (PEM). Use isto OU bearer_token."
  type        = string
  default     = null
  sensitive   = true
}

variable "client_key" {
  description = "Chave do certificado de cliente (PEM)."
  type        = string
  default     = null
  sensitive   = true
}

variable "bearer_token" {
  description = "Auth por token de ServiceAccount. Use isto OU client_certificate/client_key."
  type        = string
  default     = null
  sensitive   = true
}

variable "labels" {
  description = "Labels do cluster. São o contrato com os ApplicationSets (cluster generator)."
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations do cluster (também viram parâmetros no ApplicationSet)."
  type        = map(string)
  default     = {}
}
