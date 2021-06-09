#!/usr/bin/env python3
import sys
import json
import dns.resolver


# test with
# echo '{"data": "registry.terraform.io.,*.hashicorp.com.,*.amazonaws.com."}' | python3 main.py

def dns_lookup(domain):
  try:
    answers = dns.resolver.resolve(domain, 'CNAME')
    for rdata in answers:
      result = str(rdata.target)
    return result
  except dns.resolver.NoAnswer:
    return None
  except dns.resolver.NXDOMAIN:
    return None


def get_results(domain_list):
  allow_list = []
  for d in domain_list:
    current_domain = d
    if d.count(".") == 2 or d.startswith('*'):
      # skip root domains and wildcards
      continue
    while True:
      result = dns_lookup(current_domain)
      if result is None or result in allow_list:
        break
      allow_list.append(result)
      current_domain = result
  allow_list += domain_list               # join lists
  allow_list   = list(set(allow_list))    # unique list
  return allow_list


read         = sys.stdin.read()             # read json data from stdin
read_json    = json.loads(read)             # load json
data         = read_json['data']            # get data element
domains      = data.split(",")              # convert csv to list
unique       = get_results(domains)         # get unique list of domains with recursive cnames
to_map       = { i : "" for i in unique }   # convert list to map
dump_json    = json.dumps(to_map)           # map to json
sys.stdout.write(dump_json)                 # write json to stdout
