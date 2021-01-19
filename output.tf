
output "server_names" {
    description = "Web server names"
    value = azurerm_linux_virtual_machine.web_server[*].name
}

output "ip_addresses" {
    description = "Web server public IPs"
    value = azurerm_public_ip.web_ip[*].ip_address
}