# Azure Storage Terraform Module

This module allows you to create and manage Azure Storage Accounts, containers, blobs, queues, file shares, and tables with flexible configuration and tagging.

## Usage

### 1. main.tf

Add the module block to your `main.tf`, referencing this repository as the remote source:

```hcl
module "storage" {
  source = "git::https://github.com/rsanofi/tf-modules.git//storage?ref=v1.0.0"
  resource_group_name = var.resource_group_name
  sa_additional_tags  = var.sa_additional_tags
  storage_accounts    = var.storage_accounts
  containers          = var.containers
  blobs               = var.blobs
  queues              = var.queues
  file_shares         = var.file_shares
  tables              = var.tables
}
```

> Replace `v1.0.0` with the desired tag, branch, or commit.

### 2. var-storage.auto.tfvars

Create a `var-storage.auto.tfvars` file with your input values:

```hcl
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
    quota                = 512
  }
}
```

### 3. Apply the Module

Run the following commands:

```sh
terraform init
terraform apply -var-file="var-storage.auto.tfvars"
```

## Variables

- `resource_group_name` (string): Name of the resource group.
- `sa_additional_tags` (map): Additional tags for storage accounts.
- `storage_accounts` (map): Map of storage account objects.
- `containers` (map): Map of storage containers.
- `blobs` (map): Map of storage blobs.
- `queues` (map): Map of storage queues.
- `file_shares` (map): Map of storage file shares.
- `tables` (map): Map of storage tables.

See `variables.tf` for full details and required structure.

## Outputs

- `sa_names`, `sa_ids`, `sa_ids_map`: Storage account names and IDs
- `primary_blob_endpoints`, `primary_blob_endpoints_map`: Blob endpoints
- `primary_connection_strings`, `primary_connection_strings_map`: Connection strings
- `primary_blob_connection_strings_map`: Blob connection strings
- `primary_access_keys`, `primary_access_keys_map`: Access keys

> Some outputs are marked as sensitive and will not be displayed in plain text.

## Example

See [`Example/var-storage.auto.tfvars`](./Example/var-storage.auto.tfvars) for a complete example of input variables.

## Requirements
- Terraform >= 1.0
- AzureRM Provider >= 3.0

## Authors
- Your Name

## License
MIT
