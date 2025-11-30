# Aggregated Outputs for all VM instances
output "vm_instances" {
  description = "Map of all VM instance details"
  value = {
    for k, v in module.vm : k => {
      instance_id   = v.instance_id
      instance_name = v.instance_name
      internal_ip   = v.internal_ip
      external_ip   = v.external_ip
      zone          = v.zone
      machine_type  = v.machine_type
      self_link     = v.self_link
    }
  }
}

# Individual outputs for easy access
output "instance_ids" {
  description = "Map of instance names to their IDs"
  value       = { for k, v in module.vm : k => v.instance_id }
}

output "internal_ips" {
  description = "Map of instance names to their internal IPs"
  value       = { for k, v in module.vm : k => v.internal_ip }
}

output "external_ips" {
  description = "Map of instance names to their external IPs"
  value       = { for k, v in module.vm : k => v.external_ip }
}

output "self_links" {
  description = "Map of instance names to their self-links"
  value       = { for k, v in module.vm : k => v.self_link }
}
