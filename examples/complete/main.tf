provider "aws" {
  region = var.region
}

module "dns_firewall" {
  source = "../.."

  allowed_domains = var.allowed_domains
  vpc_ids         = var.vpc_ids
  recurse_cnames  = var.recurse_cnames
  context         = module.this.context
}
