output "vpc_networks" {
  description = "Map of VPC network details"
  value = {
    for key, vpc in module.vpc : key => {
      network_name      = vpc.network_name
      network_id        = vpc.network_id
      network_self_link = vpc.network_self_link
      subnet_names      = vpc.subnet_names
      subnet_ids        = vpc.subnet_ids
      subnet_self_links = vpc.subnet_self_links
      router_name       = vpc.router_name
      nat_name          = vpc.nat_name
    }
  }
}

output "network_self_links" {
  description = "Map of network self-links by network key"
  value       = { for key, vpc in module.vpc : key => vpc.network_self_link }
}

output "subnet_self_links" {
  description = "Map of subnet self-links by network key"
  value       = { for key, vpc in module.vpc : key => vpc.subnet_self_links }
}
