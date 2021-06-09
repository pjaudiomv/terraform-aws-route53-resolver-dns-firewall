output "id" {
  description = "ID of the created DNS firewall."
  value       = module.dns_firewall.id
}

output "rule_group_id" {
  description = "The firewall rule group id."
  value       = module.dns_firewall.firewall_rule_group_id
}

output "allowed_domains" {
  description = "The list of allowed domains added to allow rule."
  value       = module.dns_firewall.allowed_domains
}
