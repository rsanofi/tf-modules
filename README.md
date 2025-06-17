# tf-modules

Reusable Terraform modules for Azure infrastructure, including resource groups, storage, and virtual networks.

## Modules

- [`resourcegroup`](./resourcegroup): Create and manage Azure Resource Groups
- [`storage`](./storage): Provision Azure Storage Accounts, containers, blobs, queues, file shares, and tables
- [`vnet`](./vnet): Deploy Azure Virtual Networks and subnets

## Usage

Each module is designed to be used as a remote module source. Example usage for each module is provided in their respective `README.md` files.

## Requirements

- Terraform >= 1.0
- AzureRM Provider >= 3.0

## License

MIT
