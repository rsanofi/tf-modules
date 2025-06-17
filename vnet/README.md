# Azure VNet Terraform Module

This module creates one or more Azure Virtual Networks (VNets) and subnets, with support for DDOS protection, service endpoints, delegations, and tagging.

## Usage

### 1. main.tf

Add the module block to your `main.tf`, referencing this repository as the remote source:

```hcl
module "vnet" {
  source = "git::https://github.com/rsanofi/tf-modules.git//vnet?ref=v1.0.0"
  resource_group_name = var.resource_group_name
  net_location        = var.net_location
  net_additional_tags = var.net_additional_tags
  virtual_networks    = var.virtual_networks
  subnets             = var.subnets
}
```

> Replace `v1.0.0` with the desired tag, branch, or commit.

### 2. vnet.tfvars

Create a `vnet.tfvars` file with your input values:

```hcl
resource_group_name = "poc"
net_location        = null

virtual_networks = {
  virtualnetwork1 = {
    name                 = "pocvnet"
    address_space        = ["10.0.0.0/16"]
    dns_servers          = null
    ddos_protection_plan = null
  }
}

subnets = {
  subnet1 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = "pocvnet"
    name              = "loadbalancer"
    address_prefixes  = ["10.0.1.0/24"]
    service_endpoints = ["Microsoft.Sql", "Microsoft.AzureCosmosDB"]
    delegation        = []
  },
  subnet2 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = "pocvnet"
    name              = "proxy"
    address_prefixes  = ["10.0.2.0/24"]
    service_endpoints = null
    delegation        = []
  }
}

net_additional_tags = {
  iac = "Terraform"
  env = "DEV"
}
```

### 3. Apply the Module

Run the following commands:

```sh
terraform init
terraform apply -var-file="vnet.tfvars"
```

## Variables

- `resource_group_name` (string): Name of the resource group.
- `net_location` (string, optional): Location override for network resources.
- `net_additional_tags` (map): Additional tags for network resources.
- `virtual_networks` (map): Map of virtual network objects.
- `subnets` (map): Map of subnet objects.

See `variables.tf` for full details and required structure.

## Outputs

- `vnets`: All VNet resources
- `vnet_ids`: List of VNet IDs
- `map_vnet_ids`: Map of VNet names to IDs
- `vnet_names`: List of VNet names
- `vnet_locations`: List of VNet locations
- `vnet_rgnames`: List of VNet resource group names
- `subnet_ids`: List of subnet IDs
- `map_subnet_ids`: Map of subnet names to IDs

## Example

See [`Example/vnet.tfvars`](./Example/vnet.tfvars) for a complete example of input variables.

## Requirements
- Terraform >= 1.0
- AzureRM Provider >= 3.0

## Authors
- Your Name

## License
MIT
