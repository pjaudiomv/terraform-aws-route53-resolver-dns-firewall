output "id" {
  description = "ID of the created resources"
  value       = module.this.enabled ? module.this.id : null
}

output "enabled" {
  value       = module.this.enabled
  description = "Is module enabled"
}

output "allowed_domains" {
  description = "The list of allowed domains."
  value       = local.allowed_domain_list
}

output "firewall_rule_group_id" {
  description = "The firewall rule group id."
  value       = module.this.enabled ? join("", aws_route53_resolver_firewall_rule_group.default.*.id) : ""
}
