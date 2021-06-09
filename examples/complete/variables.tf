variable "region" {
  type        = string
  description = "AWS region"
}

variable "allowed_domains" {
  description = "list of domains allowed"
  type        = list(string)
}

variable "vpc_ids" {
  description = "A list of VPC IDS to associate with the firewall rule group."
  type        = list(string)
}

variable "recurse_cnames" {
  description = "Recursively get all CNAME records for sub-domains."
  type        = bool
}
