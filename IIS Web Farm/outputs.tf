output "ip" {
  value = "${azurerm_public_ip.loadbalancer01-pubip.ip_address}"
}