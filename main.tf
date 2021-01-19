locals {
  project_string = "${replace(var.project_name, " ", "_")}_${var.project_environment}"
}

data "azurerm_resource_group" "dev_rg" {
  name = var.rg_name
}

data "azurerm_subnet" "web_subnet" {
  name                 = var.rg_web_subnet_name
  virtual_network_name = var.rg_virtual_network_name
  resource_group_name  = data.azurerm_resource_group.dev_rg.name
  depends_on = [ data.azurerm_resource_group.dev_rg ]
} 

resource "azurerm_public_ip" "web_ip" {
  name                = "${local.project_string}-publicip-${count.index}"
  count = var.server_count
  location            = data.azurerm_resource_group.dev_rg.location
  resource_group_name = data.azurerm_resource_group.dev_rg.name
  allocation_method   = "Dynamic"
}
 
resource "azurerm_network_interface" "nic" {
  name                = "${local.project_string}-nic-${count.index}"
  count = var.server_count
  location            = data.azurerm_resource_group.dev_rg.location
  resource_group_name = data.azurerm_resource_group.dev_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_ip[count.index].id
  }
}

resource "azurerm_linux_virtual_machine" "web_server" {
  name                = "web-server-${count.index}"
  count = var.server_count
  location            = data.azurerm_resource_group.dev_rg.location
  resource_group_name = data.azurerm_resource_group.dev_rg.name
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  tags = {
    "Project" = var.project_name
    "Role" = var.project_environment
  }
}