# aws-github-oidc

Federação **GitHub Actions → AWS via OIDC**: o workflow troca um JWT de curta duração
por credenciais STS. Assim nenhuma access key fica guardada em secret do GitHub.

```hcl
module "github_oidc" {
  source = "git::https://github.com/patrickcmartins/terraform-modules.git//modules/aws-github-oidc?ref=v0.1.0"

  roles = {
    gha-infra-live-plan = {
      subjects            = ["repo:patrickcmartins/infra-live:pull_request", "repo:patrickcmartins/infra-live:ref:refs/heads/main"]
      managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
    }
  }
}
```

A validação do módulo bloqueia `repo:org/*`, porque um subject amplo demais é a falha de segurança mais comum nessa configuração.
