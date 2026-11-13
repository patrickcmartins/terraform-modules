variable "name" {
  description = "Nome do cluster kind (vira o prefixo dos containers: <name>-control-plane)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,30}$", var.name))
    error_message = "name deve ser DNS-safe: minúsculas, números e '-', 2 a 31 caracteres."
  }
}

variable "node_image" {
  description = "Imagem do node kind. Fixe versão + digest para builds reprodutíveis."
  type        = string
  default     = "kindest/node:v1.36.4@sha256:099e049362a1526b2db71494e1947aae99bd16290d7c895f2b7ea312e3cbfaed"

  validation {
    condition     = can(regex("@sha256:[a-f0-9]{64}$", var.node_image))
    error_message = "node_image precisa estar fixada por digest (@sha256:...)."
  }
}

variable "worker_count" {
  description = "Quantidade de workers além do control-plane. 0 economiza RAM."
  type        = number
  default     = 0

  validation {
    condition     = var.worker_count >= 0 && var.worker_count <= 3
    error_message = "worker_count deve estar entre 0 e 3."
  }
}

variable "port_mappings" {
  description = "Portas do host mapeadas para o control-plane (ex.: NodePort do ingress gateway)."
  type = list(object({
    container_port = number
    host_port      = number
  }))
  default = []
}

variable "node_labels" {
  description = "Labels aplicados ao control-plane via kubelet (ex.: ingress-ready=true)."
  type        = map(string)
  default     = {}
}

variable "kubeconfig_path" {
  description = "Onde gravar o kubeconfig. null = <diretório do root module>/.kubeconfig-<name>."
  type        = string
  default     = null
}
