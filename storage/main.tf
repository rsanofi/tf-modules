
data "azurerm_resource_group" "this" {
  name  = var.resource_group_name
}


# -
# - Get the current user config
# -
data "azurerm_client_config" "current" {}

locals {
  tags                       = merge(data.azurerm_resource_group.this.tags, var.sa_additional_tags)
  

  default_network_rules = {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
  disable_network_rules = {
    bypass                     = ["None"]
    default_action             = "Allow"
    ip_rules                   = null
    virtual_network_subnet_ids = null
  }

  blobs = {
    for b in var.blobs : b.name => merge({
      type         = "Block"
      size         = 0
      content_type = "application/octet-stream"
      source_file  = null
      source_uri   = null
      metadata     = {}
    }, b)
  }
}

# -
# - Storage Account
# -
resource "azurerm_storage_account" "this" {
  for_each                  = var.storage_accounts
  name                      = each.value["name"]
  resource_group_name       = data.azurerm_resource_group.this.name
  location                  = data.azurerm_resource_group.this.location
  account_tier              = coalesce(lookup(each.value, "account_kind"), "StorageV2") == "FileStorage" ? "Premium" : split("_", each.value["sku"])[0]
  account_replication_type  = coalesce(lookup(each.value, "account_kind"), "StorageV2") == "FileStorage" ? "LRS" : split("_", each.value["sku"])[1]
  account_kind              = coalesce(lookup(each.value, "account_kind"), "StorageV2")
  access_tier               = lookup(each.value, "access_tier", null)
  https_traffic_only_enabled = true 

  min_tls_version          = lookup(each.value, "min_tls_version", "TLS1_2")
  large_file_share_enabled = coalesce(each.value.large_file_share_enabled, false)

 
  dynamic "identity" {
    for_each = coalesce(lookup(each.value, "assign_identity"), false) == false ? [] : tolist([lookup(each.value, "assign_identity", false)])
    content {
      type = "SystemAssigned"
    }
  }

 
  dynamic "network_rules" {
    for_each = lookup(each.value, "network_rules", null) != null ? [merge(local.default_network_rules, lookup(each.value, "network_rules", null))] : [local.default_network_rules]
    content {
      bypass                     = network_rules.value.bypass
      default_action             = network_rules.value.default_action
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids
    }
  }

  tags = local.tags
}


# -
# - Container
# -
resource "azurerm_storage_container" "this" {
  for_each              = var.containers
  name                  = each.value["name"]
  storage_account_name  = each.value["storage_account_name"]
  container_access_type = coalesce(lookup(each.value, "container_access_type"), "private")
  depends_on = [
    azurerm_storage_account.this
  ]
}

# -
# - Blob
# -
resource "azurerm_storage_blob" "this" {
  for_each               = local.blobs
  name                   = each.value["name"]
  storage_account_name   = each.value["storage_account_name"]
  storage_container_name = each.value["storage_container_name"]
  type                   = each.value["type"]
  size                   = lookup(each.value, "size", null)
  content_type           = lookup(each.value, "content_type", null)
  source_uri             = lookup(each.value, "source_uri", null)
  metadata               = lookup(each.value, "metadata", null)
  depends_on = [
    azurerm_storage_account.this,
    azurerm_storage_container.this
  ]
}

# -
# - Queue
# -
resource "azurerm_storage_queue" "this" {
  for_each             = var.queues
  name                 = each.value["name"]
  storage_account_name = each.value["storage_account_name"]
  depends_on = [
    azurerm_storage_account.this
  ]
}

# -
# - File Share
# -
resource "azurerm_storage_share" "this" {
  for_each             = var.file_shares
  name                 = each.value["name"]
  storage_account_name = each.value["storage_account_name"]
  quota                = coalesce(lookup(each.value, "quota"), 110)
  depends_on = [
    azurerm_storage_account.this
  ]
}

# -
# - Table
# -
resource "azurerm_storage_table" "this" {
  for_each             = var.tables
  name                 = each.value["name"]
  storage_account_name = each.value["storage_account_name"]
  depends_on = [
    azurerm_storage_account.this
  ]
}

