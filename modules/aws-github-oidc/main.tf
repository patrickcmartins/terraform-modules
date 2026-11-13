locals {
  issuer = "token.actions.githubusercontent.com"
  provider_arn = var.create_provider ? aws_iam_openid_connect_provider.github[0].arn : (
    data.aws_iam_openid_connect_provider.github[0].arn
  )

  managed_attachments = merge([
    for role, cfg in var.roles : {
      for arn in cfg.managed_policy_arns : "${role}|${arn}" => { role = role, arn = arn }
    }
  ]...)
}

resource "aws_iam_openid_connect_provider" "github" {
  count = var.create_provider ? 1 : 0

  url            = "https://${local.issuer}"
  client_id_list = ["sts.amazonaws.com"]
  # Desde 2023 a AWS valida o certificado do GitHub pela própria CA confiável;
  # o thumbprint é ignorado, mas a API ainda aceita a lista.
  tags = var.tags
}

data "aws_iam_openid_connect_provider" "github" {
  count = var.create_provider ? 0 : 1
  url   = "https://${local.issuer}"
}

data "aws_iam_policy_document" "trust" {
  for_each = var.roles

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [local.provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.issuer}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "${local.issuer}:sub"
      values   = each.value.subjects
    }
  }
}

resource "aws_iam_role" "this" {
  for_each = var.roles

  name                 = each.key
  assume_role_policy   = data.aws_iam_policy_document.trust[each.key].json
  max_session_duration = each.value.max_session_duration
  tags                 = var.tags
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = local.managed_attachments

  role       = aws_iam_role.this[each.value.role].name
  policy_arn = each.value.arn
}

resource "aws_iam_role_policy" "inline" {
  for_each = { for k, v in var.roles : k => v if v.inline_policy_json != null }

  name   = "inline"
  role   = aws_iam_role.this[each.key].id
  policy = each.value.inline_policy_json
}
