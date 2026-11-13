locals {
  kubeconfig_path = coalesce(var.kubeconfig_path, "${path.root}/.kubeconfig-${var.name}")
  node_labels     = join(",", [for k, v in var.node_labels : "${k}=${v}"])
}

resource "kind_cluster" "this" {
  name            = var.name
  node_image      = var.node_image
  kubeconfig_path = local.kubeconfig_path
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      kubeadm_config_patches = local.node_labels == "" ? [] : [
        <<-EOT
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "${local.node_labels}"
        EOT
      ]

      dynamic "extra_port_mappings" {
        for_each = var.port_mappings
        content {
          container_port = extra_port_mappings.value.container_port
          host_port      = extra_port_mappings.value.host_port
          listen_address = "127.0.0.1"
          protocol       = "TCP"
        }
      }
    }

    dynamic "node" {
      for_each = range(var.worker_count)
      content {
        role = "worker"
      }
    }
  }
}
