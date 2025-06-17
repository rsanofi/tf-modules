
data "azurerm_resource_group" "this" {
  name  = var.resource_group_name
}

locals {
  location                   = var.net_location == null ? data.azurerm_resource_group.this.location : var.net_location
  tags                       = merge(var.net_additional_tags, data.azurerm_resource_group.this.tags)
}

# -
# - Virtual Network
# -
resource "azurerm_virtual_network" "this" {
  for_each            = var.virtual_networks
  name                = each.value["name"]
  location            = local.location
  resource_group_name = data.azurerm_resource_group.this.name
  address_space       = each.value["address_space"]
  dns_servers         = lookup(each.value, "dns_servers", null)

  dynamic "ddos_protection_plan" {
    for_each = lookup(each.value, "ddos_protection_plan", null) != null ? list(lookup(each.value, "ddos_protection_plan")) : []
    content {
      id     = lookup(ddos_protection_plan.value, "id", null)
      enable = coalesce(lookup(ddos_protection_plan.value, "enable"), false)
    }
  }

  tags = local.tags
}


# -
# - Subnet
# -
resource "azurerm_subnet" "this" {
  for_each                                       = var.subnets
  name                                           = each.value["name"]
  resource_group_name                            = data.azurerm_resource_group.this.name
  address_prefixes                               = each.value["address_prefixes"]
  service_endpoints                              = coalesce(lookup(each.value, "pe_enable"), false) == false ? lookup(each.value, "service_endpoints", null) : null
  virtual_network_name                           = each.value.vnet_key != null ? lookup(var.virtual_networks, each.value["vnet_key"])["name"] : each.value["vnet_name"]

  dynamic "delegation" {
    for_each = coalesce(lookup(each.value, "delegation"), [])
    content {
      name = lookup(delegation.value, "name", null)
      dynamic "service_delegation" {
        for_each = coalesce(lookup(delegation.value, "service_delegation"), [])
        content {
          name    = lookup(service_delegation.value, "name", null)
          actions = lookup(service_delegation.value, "actions", null)
        }
      }
    }
  }

  depends_on = [azurerm_virtual_network.this]
}
