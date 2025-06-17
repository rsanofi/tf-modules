resource_group_name = "poc-rm"
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
    vnet_name         = pocvnet
    name              = "loadbalancer"
    address_prefixes  = ["10.0.1.0/24"]
    service_endpoints = ["Microsoft.Sql", "Microsoft.AzureCosmosDB"]
    delegation        = []
  },
  subnet2 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = pocvnet
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