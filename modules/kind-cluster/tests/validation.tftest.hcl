# Testes unitários: mock_provider = nenhum container é criado.
mock_provider "kind" {}

run "defaults_are_valid" {
  command = plan

  variables {
    name = "unit-test"
  }

  assert {
    condition     = output.internal_endpoint == "https://unit-test-control-plane:6443"
    error_message = "internal_endpoint deve apontar para o container do control-plane."
  }
}

run "rejects_unpinned_image" {
  command = plan

  variables {
    name       = "unit-test"
    node_image = "kindest/node:v1.36.4"
  }

  expect_failures = [var.node_image]
}

run "rejects_invalid_name" {
  command = plan

  variables {
    name = "Invalid_Name"
  }

  expect_failures = [var.name]
}
