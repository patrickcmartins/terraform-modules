data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  is_lab = var.cost_profile == "lab"
  azs    = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  public_subnets  = [for i, _ in local.azs : cidrsubnet(var.vpc_cidr, 8, i)]
  private_subnets = [for i, _ in local.azs : cidrsubnet(var.vpc_cidr, 4, i + 1)]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = var.name
  cidr = var.vpc_cidr
  azs  = local.azs

  public_subnets  = local.public_subnets
  private_subnets = local.is_lab ? [] : local.private_subnets

  # lab: sem NAT (~US$32/mês por AZ economizados); nodes ganham IP público.
  enable_nat_gateway      = !local.is_lab
  one_nat_gateway_per_az  = !local.is_lab
  map_public_ip_on_launch = local.is_lab

  public_subnet_tags  = { "kubernetes.io/role/elb" = "1" }
  private_subnet_tags = { "kubernetes.io/role/internal-elb" = "1" }

  tags = var.tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.name
  kubernetes_version = var.kubernetes_version

  endpoint_public_access       = true
  endpoint_private_access      = true
  endpoint_public_access_cidrs = var.public_access_cidrs

  # Quem cria o cluster (role do Atlantis/deployer) vira admin via Access Entry.
  enable_cluster_creator_admin_permissions = true
  authentication_mode                      = "API"
  access_entries                           = var.access_entries

  vpc_id     = module.vpc.vpc_id
  subnet_ids = local.is_lab ? module.vpc.public_subnets : module.vpc.private_subnets

  addons = {
    coredns                = {}
    kube-proxy             = {}
    vpc-cni                = { before_compute = true }
    eks-pod-identity-agent = { before_compute = true }
  }

  # Webhooks que rodam em pods (istiod 15017, etc.): o control plane precisa alcançar o node.
  # O módulo upstream só libera 443/4443/6443/8443/9443/10250; o resto vem por aqui.
  node_security_group_additional_rules = {
    for port in var.webhook_ports : "ingress_cluster_webhook_${port}" => {
      description                   = "Control plane to pod webhook port ${port}"
      protocol                      = "tcp"
      from_port                     = port
      to_port                       = port
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  eks_managed_node_groups = {
    default = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = var.instance_types
      capacity_type  = local.is_lab ? "SPOT" : "ON_DEMAND"

      min_size     = var.node_count
      max_size     = var.node_count + (local.is_lab ? 0 : 2)
      desired_size = var.node_count
    }
  }

  tags = var.tags
}
