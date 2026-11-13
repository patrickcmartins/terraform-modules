variable "create_provider" {
  description = "Cria o OIDC provider do GitHub (só existe UM por conta). false = reutiliza o existente."
  type        = bool
  default     = true
}

variable "roles" {
  description = <<-EOT
    Roles assumíveis por workflows do GitHub Actions via OIDC (sem access keys!).
    subjects: padrões do claim "sub", ex.:
      "repo:org/repo:ref:refs/heads/main"   -> só a branch main
      "repo:org/repo:environment:prod"      -> só jobs no environment prod
      "repo:org/repo:pull_request"          -> PRs
  EOT
  type = map(object({
    subjects             = list(string)
    managed_policy_arns  = optional(list(string), [])
    inline_policy_json   = optional(string)
    max_session_duration = optional(number, 3600)
  }))

  validation {
    condition = alltrue(flatten([
      for r in values(var.roles) : [for s in r.subjects : !can(regex("^repo:[^/]+/\\*", s)) && s != "*"]
    ]))
    error_message = "Wildcard de organização/repo inteiro no subject é proibido (risco de qualquer repo assumir a role)."
  }
}

variable "tags" {
  description = "Tags extras."
  type        = map(string)
  default     = {}
}
