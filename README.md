# terraform-azurerm-webserver-azure
A Terraform module to create web servers in Azure 

## Overview
The webserver-azure module creates web servers in an Azure resource group and associated public ips.  

## Requirements
The calling code must create an `azurerm` provider which has rights to create the virtual machines and ips.

## Usage

```hcl
provider "azurerm" {
  features {}
}

module "webservers" {
    source = "app.terraform.io/csmith/webserver-azure/azurerm"

    project_name        = "Demo Test"
    project_environment = "DEV"
    server_count = 2
    ssh_public_key "xxxxxxxx"
    rg_name = "test-rg"
    rg_virtual_network_name = "test-network"
    rg_web_subnet_name = "web-subnet"

}
```
