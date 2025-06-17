# #############################################################################
# # OUTPUTS Resource Group
# #############################################################################

output "resource_group_ids_map" {
  value       = { for r in azurerm_resource_group.this : r.name => r.id }
  description = "The Map of the Resource Group Id's."
}


