variable "name" {
  description = "Nome do cluster EKS (e prefixo da VPC)."
  type        = string
}

variable "kubernetes_version" {
  description = "Versão do Kubernetes no EKS."
  type        = string
  default     = "1.34"
}

variable "vpc_cidr" {
  description = "CIDR da VPC."
  type        = string
  default     = "10.40.0.0/16"
}

variable "az_count" {
  description = "Quantidade de AZs (EKS exige no mínimo 2)."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "az_count deve ser 2 ou 3."
  }
}

variable "cost_profile" {
  description = <<-EOT
    "lab":  só subnets públicas, sem NAT Gateway, nodes SPOT (barato, NÃO é para produção).
    "prod": subnets privadas + NAT por AZ, nodes ON_DEMAND, endpoint privado + público restrito.
  EOT
  type        = string
  default     = "lab"

  validation {
    condition     = contains(["lab", "prod"], var.cost_profile)
    error_message = "cost_profile deve ser lab ou prod."
  }
}

variable "instance_types" {
  description = "Tipos de instância do node group (vários = mais chance de SPOT)."
  type        = list(string)
  default     = ["t3.medium", "t3a.medium"]
}

variable "node_count" {
  description = "Nodes desejados (min=max=desired para o lab ser previsível)."
  type        = number
  default     = 2
}

variable "public_access_cidrs" {
  description = "CIDRs que podem acessar o endpoint público da API. Restrinja ao seu IP."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "access_entries" {
  description = "Acessos extras ao cluster (EKS Access Entries), ex.: role SSO dos admins, role do Atlantis."
  type        = any
  default     = {}
}

variable "tags" {
  description = "Tags extras."
  type        = map(string)
  default     = {}
}
