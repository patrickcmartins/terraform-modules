# Fronteira Terraform x GitOps:
#   Terraform instala o Argo CD e UMA Application (root). Tudo que vem depois
#   (addons, apps, outros clusters) é reconciliado pelo Argo CD a partir do Git.

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_version

  values = concat([file("${path.module}/values/argocd.yaml")], var.values)

  wait    = true
  timeout = 600
}

resource "helm_release" "root_app" {
  name       = "argocd-root"
  namespace  = var.namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = var.apps_chart_version

  values = [yamlencode({
    applications = {
      (var.root_app.name) = {
        namespace  = var.namespace
        project    = "default"
        finalizers = ["resources-finalizer.argocd.argoproj.io"]
        source = {
          repoURL        = var.root_app.repo_url
          targetRevision = var.root_app.revision
          path           = var.root_app.path
        }
        destination = {
          server    = "https://kubernetes.default.svc"
          namespace = var.namespace
        }
        syncPolicy = {
          automated = { prune = true, selfHeal = true }
        }
      }
    }
  })]

  depends_on = [helm_release.argocd]
}
