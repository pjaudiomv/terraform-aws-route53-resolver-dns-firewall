locals {
  allowed_domain_list = module.this.enabled && var.recurse_cnames ? keys(data.external.python[0].result) : var.allowed_domains
}

data "external" "python" {
  count   = module.this.enabled && var.recurse_cnames ? 1 : 0
  program = ["python3", "${path.module}/main.py"]
  query = {
    data = join(",", var.allowed_domains)
  }
}

resource "aws_route53_resolver_firewall_rule_group" "default" {
  count = module.this.enabled ? 1 : 0
  name  = module.this.id
  tags  = module.this.tags
}

resource "aws_route53_resolver_firewall_domain_list" "default" {
  count   = module.this.enabled ? 1 : 0
  name    = "${module.this.id}-allow"
  domains = local.allowed_domain_list
  tags    = module.this.tags
}

resource "aws_route53_resolver_firewall_domain_list" "additional" {
  count = module.this.enabled ? 1 : 0
  name  = "${module.this.id}-block"
  domains = [
    "*.",
    "."
  ]
  tags = module.this.tags
}

resource "aws_route53_resolver_firewall_rule" "default" {
  count                   = module.this.enabled ? 1 : 0
  name                    = module.this.id
  action                  = "ALLOW"
  firewall_domain_list_id = join("", aws_route53_resolver_firewall_domain_list.default.*.id)
  firewall_rule_group_id  = join("", aws_route53_resolver_firewall_rule_group.default.*.id)
  priority                = 100
}

resource "aws_route53_resolver_firewall_rule" "additional" {
  count                   = module.this.enabled ? 1 : 0
  name                    = module.this.id
  action                  = "BLOCK"
  block_response          = var.block_response
  firewall_domain_list_id = join("", aws_route53_resolver_firewall_domain_list.additional.*.id)
  firewall_rule_group_id  = join("", aws_route53_resolver_firewall_rule_group.default.*.id)
  priority                = 200
}

resource "aws_route53_resolver_firewall_rule_group_association" "default" {
  for_each               = module.this.enabled ? toset(var.vpc_ids) : toset(false)
  name                   = module.this.id
  firewall_rule_group_id = join("", aws_route53_resolver_firewall_rule_group.default.*.id)
  priority               = 300
  vpc_id                 = each.key
}
