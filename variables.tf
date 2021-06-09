variable "allowed_domains" {
  description = "list of domains allowed"
  type        = list(string)
  validation {
    condition     = length([for i in var.allowed_domains : i if length(regexall(".*[./]$", i)) > 0]) == length(var.allowed_domains)
    error_message = "All domains must end in a period."
  }
}

variable "recurse_cnames" {
  description = "Recursively get all CNAME records for sub-domains."
  type        = bool
  default     = false
}

variable "vpc_ids" {
  description = "A list of VPC IDS to associate with the firewall rule group."
  type        = list(string)
}

variable "block_response" {
  description = "The way that you want DNS Firewall to block the request. Supported Valid values: NODATA, NXDOMAIN."
  type        = string
  default     = "NXDOMAIN"
}
