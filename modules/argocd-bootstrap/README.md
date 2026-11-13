# argocd-bootstrap

Instala o Argo CD via Helm e cria **uma** Application `root` (app-of-apps).
É o ponto exato onde o Terraform entrega o controle ao GitOps.

Requer um provider `helm` configurado pelo chamador.

```hcl
module "argocd" {
  source = "git::https://github.com/patrickcmartins/terraform-modules.git//modules/argocd-bootstrap?ref=v0.1.0"

  root_app = {
    repo_url = "https://github.com/patrickcmartins/platform-gitops.git"
    path     = "bootstrap/hub"
  }
}
```
