provider "azurerm" {
  version         = "~> 4.20.0"
  features {}
}

# Set the terraform backend
terraform {
  required_version = ">= 1.0"
  backend "azurerm" {} 
}
