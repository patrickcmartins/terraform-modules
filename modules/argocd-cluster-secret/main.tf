locals {
  use_token = var.bearer_token != null

  tls_client_config = merge(
    { caData = base64encode(var.ca_data) },
    local.use_token ? {} : {
      certData = base64encode(coalesce(var.client_certificate, "missing"))
      keyData  = base64encode(coalesce(var.client_key, "missing"))
    },
  )

  config = merge(
    { tlsClientConfig = local.tls_client_config },
    local.use_token ? { bearerToken = var.bearer_token } : {},
  )
}

# Registro declarativo de cluster: o Argo CD descobre clusters por Secrets
# com o label argocd.argoproj.io/secret-type=cluster.
resource "kubernetes_secret_v1" "this" {
  metadata {
    name        = "cluster-${var.name}"
    namespace   = var.namespace
    annotations = var.annotations
    labels = merge(var.labels, {
      "argocd.argoproj.io/secret-type" = "cluster"
      "app.kubernetes.io/managed-by"   = "terraform"
    })
  }

  data = {
    name   = var.name
    server = var.server
    config = jsonencode(local.config)
  }

  lifecycle {
    precondition {
      condition     = local.use_token || (var.client_certificate != null && var.client_key != null)
      error_message = "Informe bearer_token OU client_certificate + client_key."
    }
  }
}
