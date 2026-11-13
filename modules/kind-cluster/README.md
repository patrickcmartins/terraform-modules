# kind-cluster

Cria um cluster [kind](https://kind.sigs.k8s.io/) com imagem fixada por digest, port mappings
opcionais e labels de node.

```hcl
module "cluster" {
  source = "git::https://github.com/patrickcmartins/terraform-modules.git//modules/kind-cluster?ref=v0.1.0"

  name        = "kind-dev"
  node_labels = { "ingress-ready" = "true" }
  port_mappings = [
    { container_port = 30080, host_port = 28080 },
  ]
}
```

| Output | Uso |
|---|---|
| `endpoint` | provider helm/kubernetes rodando no host (ou no Atlantis com `network_mode: host`) |
| `internal_endpoint` | registrar este cluster no Argo CD de **outro** cluster kind |

Testes: `terraform init && terraform test` (usa `mock_provider`, não cria nada).
