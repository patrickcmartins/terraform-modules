mock_provider "kubernetes" {}

variables {
  name    = "spoke"
  server  = "https://spoke-control-plane:6443"
  ca_data = "-----BEGIN CERTIFICATE-----\nfake\n-----END CERTIFICATE-----"
  labels  = { cloud = "kind" }
}

run "token_auth" {
  command = plan
  variables {
    bearer_token = "abc"
  }
  assert {
    condition     = kubernetes_secret_v1.this.metadata[0].labels["argocd.argoproj.io/secret-type"] == "cluster"
    error_message = "Secret precisa do label de cluster do Argo CD."
  }
}

run "missing_auth_fails" {
  command         = plan
  expect_failures = [kubernetes_secret_v1.this]
}
