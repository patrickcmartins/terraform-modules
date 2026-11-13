# terraform-modules

Módulos Terraform reutilizáveis, **versionados por tag semver** e consumidos pelo
[`infra-live`](https://github.com/patrickcmartins/infra-live):

```hcl
source = "git::https://github.com/patrickcmartins/terraform-modules.git//modules/<nome>?ref=vX.Y.Z"
```

| Módulo | O que faz |
|---|---|
| [`kind-cluster`](modules/kind-cluster) | Cluster kind com imagem fixada por digest |
| [`argocd-bootstrap`](modules/argocd-bootstrap) | Argo CD + root app (ponto de handoff Terraform → GitOps) |
| [`argocd-cluster-secret`](modules/argocd-cluster-secret) | Registra um cluster spoke no Argo CD hub |
| [`aws-eks`](modules/aws-eks) | VPC + EKS (perfis `lab`/`prod`) |
| [`aws-github-oidc`](modules/aws-github-oidc) | GitHub Actions → AWS sem access keys |

## Fluxo de mudança

1. Abra um PR com [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `feat!:`).
2. O CI roda o reusable workflow do [`terraform-workflows`](https://github.com/patrickcmartins/terraform-workflows): fmt, validate, tflint, trivy e `terraform test`.
3. No merge, o **release-please** abre um PR de release. Quando esse PR é mergeado, ele cria a tag `vX.Y.Z` e o CHANGELOG.
4. O `infra-live` sobe o `?ref=` **por ambiente** (dev primeiro, prod depois).

`feat!:` ou `BREAKING CHANGE:` gera um bump de major, para que nenhum consumidor quebre sem perceber.
