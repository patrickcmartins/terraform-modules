# aws-eks

Wrapper opinativo sobre `terraform-aws-modules/vpc` + `terraform-aws-modules/eks` (v21).

* `cost_profile = "lab"`: subnets públicas, **sem NAT**, nodes SPOT. Custa ~US$0,20/h.
  **Destrua depois da demo.**
* `cost_profile = "prod"`: subnets privadas, NAT por AZ e nodes on-demand com espaço para crescer.

Os riscos aceitos no perfil lab ficam documentados no `.trivyignore` do repositório que consome o módulo.
