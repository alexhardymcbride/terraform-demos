resource "azurerm_virtual_network" "vnet01" {
    name                =   "${var.vnetname}"
    location            =   "${azurerm_resource_group.resourcegroup01.location}"
    resource_group_name =   "${azurerm_resource_group.resourcegroup01.name}"
    address_space       =   "${var.vnetaddressspace}"
}

resource "azurerm_subnet" "vnet01-subnet01" {
    name                        =   "${var.subnetname}"
    resource_group_name         =   "${azurerm_virtual_network.vnet01.resource_group_name}"
    virtual_network_name        =   "${azurerm_virtual_network.vnet01.name}"
    address_prefix              =   "${var.subnetprefix}"
}

resource "azurerm_network_security_group" "vnet01-subnet01-nsg" {
    name                =   "${azurerm_virtual_network.vnet01.name}-subnet01-nsg"
    location            =   "${azurerm_virtual_network.vnet01.location}"
    resource_group_name =   "${azurerm_virtual_network.vnet01.resource_group_name}"
}

resource "azurerm_network_security_rule" "vnet01-subnet01-nsg-httpinrule" {
    name                        =   "AllowHTTP"
    priority                    =   100
    direction                   =   "Inbound"
    access                      =   "Allow"
    protocol                    =   "Tcp"
    source_port_range           =   "*"
    destination_port_range      =   "80"
    source_address_prefix       =   "*"
    destination_address_prefix  =   "*"
    resource_group_name         =   "${azurerm_network_security_group.vnet01-subnet01-nsg.resource_group_name}"
    network_security_group_name =   "${azurerm_network_security_group.vnet01-subnet01-nsg.name}"
}

resource "azurerm_subnet_network_security_group_association" "vnet01-subnet01-nsg-assoc" {
    network_security_group_id   =   "${azurerm_network_security_group.vnet01-subnet01-nsg.id}"
    subnet_id                   =   "${azurerm_subnet.vnet01-subnet01.id}"
}
