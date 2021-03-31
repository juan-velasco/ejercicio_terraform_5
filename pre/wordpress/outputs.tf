output "public_ip" {
  value = azurerm_container_group.aci-example.ip_address
}

output "fqdn" {
  value = azurerm_container_group.aci-example.fqdn
}