# Azure Resource Group Terraform Module

This module allows you to create and manage one or more Azure Resource Groups with tags.

## Usage

### 1. main.tf

Add the module block to your `main.tf`, referencing this repository as the remote source:

```hcl
module "resourcegroup" {
  source = "git::https://github.com/rsanofi/tf-modules.git//resourcegroup?ref=v1.0.0"
  resource_groups = var.resource_groups
}
```

> Replace `v1.0.0` with the desired tag, branch, or commit.

### 2. var-resourcegroup.auto.tfvars

Create a `var-resourcegroup.auto.tfvars` file with your input values:

```hcl
resource_groups = {
  resource_group_1 = {
    name     = "poc"
    location = "eastus2"
    tags = {
      created_by  = "aadcs"
      contact_dl  = "addcs"
      cost_center = "00000"
    }
  }
}
```

### 3. Apply the Module

Run the following commands:

```sh
terraform init
terraform apply -var-file="var-resourcegroup.auto.tfvars"
```

## Variables

- `resource_groups` (map): Map of resource group objects. Each object must have:
  - `name` (string): Name of the resource group
  - `location` (string): Azure region
  - `tags` (map): Tags to assign

See `variables.tf` for full details and required structure.

## Outputs

- `resource_group_ids_map`: Map of resource group names to their IDs

## Example

See [`Example/var-resourcegroup.auto.tfvars`](./Example/var-resourcegroup.auto.tfvars) for a complete example of input variables.

## Requirements
- Terraform >= 1.0
- AzureRM Provider >= 3.0

## Authors
- Your Name

## License
MIT
