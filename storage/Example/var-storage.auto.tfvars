resource_group_name = "jstart-vmss-layered07142020"

storage_accounts = {
  sa1 = {
    name                     = "jstartlayer08202020sa"
    sku                      = "Standard_LRS"
    account_kind             = null
    access_tier              = null
    assign_identity          = true
    min_tls_version          = "TLS1_2"
    large_file_share_enabled = true
    network_rules            = null
  }
}

containers = {
  container1 = {
    name                  = "test"
    storage_account_name  = "jstartlayer08202020sa"
    container_access_type = "private"
  }
}

blobs = {
  blob1 = {
    name                   = "test"
    storage_account_name   = "jstartlayer08202020sa"
    storage_container_name = "test"
    type                   = "Block"
    size                   = null
    content_type           = null
    source_uri             = null
    metadata               = {}
  }
}

queues = {
  queue1 = {
    name                 = "test1"
    storage_account_name = "jstartlayer08202020sa"
  }
}

file_shares = {
  share1 = {
    name                 = "share1"
    storage_account_name = "jstartlayer08202020sa"
    quota                = "512"
  }
}

tables = {
  table1 = {
    name                 = "table1"
    storage_account_name = "jstartlayer08202020sa"
  }
}

sa_additional_tags = {
  iac       = "Terraform"
  env       = "DEV"
}