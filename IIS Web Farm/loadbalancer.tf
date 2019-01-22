resource "azurerm_public_ip" "loadbalancer01-pubip" {
    name                =   "${var.lbname}-pubip"
    location            =   "${azurerm_resource_group.resourcegroup01.location}"
    resource_group_name =   "${azurerm_resource_group.resourcegroup01.name}"
    allocation_method   =   "Static"
}

resource "azurerm_lb" "loadbalancer01" {
    name                =   "${var.lbname}"
    location            =   "${azurerm_resource_group.resourcegroup01.location}"
    resource_group_name =   "${azurerm_resource_group.resourcegroup01.name}"

    frontend_ip_configuration {
        name    =   "lbfrontendip"
        public_ip_address_id    =   "${azurerm_public_ip.loadbalancer01-pubip.id}"
    }
}

resource "azurerm_lb_backend_address_pool" "loadbalancer01-bepool" {
    name                =   "${var.lbname}-bepool"
    loadbalancer_id     =   "${azurerm_lb.loadbalancer01.id}"
    resource_group_name =   "${azurerm_resource_group.resourcegroup01.name}"
}

resource "azurerm_network_interface_backend_address_pool_association" "loadbalancer01-bepool-assoc" {
    count                   =   "${var.servercount}"
    network_interface_id    =   "${element(azurerm_network_interface.webservers-nics01.*.id, count.index)}"
    ip_configuration_name   =   "ipconfig01"
    backend_address_pool_id =   "${azurerm_lb_backend_address_pool.loadbalancer01-bepool.id}"
}

resource "azurerm_lb_probe" "loadbalancer01-healthprobe" {
    resource_group_name =   "${azurerm_resource_group.resourcegroup01.name}"
    loadbalancer_id     =   "${azurerm_lb.loadbalancer01.id}"
    name                =   "http-running-probe"
    port                =   80
}

resource "azurerm_lb_rule" "loadbalancer01-lbrule" {
  resource_group_name               =   "${azurerm_resource_group.resourcegroup01.name}"
  loadbalancer_id                   =   "${azurerm_lb.loadbalancer01.id}"
  name                              =   "LBRule"
  protocol                          =   "Tcp"
  frontend_port                     =   80
  backend_port                      =   80
  frontend_ip_configuration_name    =   "lbfrontendip"
  backend_address_pool_id           =   "${azurerm_lb_backend_address_pool.loadbalancer01-bepool.id}"
  load_distribution                 =   "Default"
  probe_id                          =   "${azurerm_lb_probe.loadbalancer01-healthprobe.id}"
}