# argocd-cluster-secret

Registra um cluster no Argo CD (hub) de forma declarativa, via Secret.
Os `labels` são o contrato com os ApplicationSets do `platform-gitops`:

| label | valores | efeito |
|---|---|---|
| `cloud` | `kind`, `aws` | escolhe `values-<cloud>.yaml` dos addons |
| `env` | `dev`, `prod`, `mgmt` | ambiente |
| `mesh` | `istio`, `none` | instala Istio no cluster |
| `workloads` | `enabled` | recebe aplicações de negócio |
