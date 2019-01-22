resource "azurerm_availability_set" "webservers-availset01" {
    name                =   "${var.servername}-availablityset"
    location            =   "${azurerm_resource_group.resourcegroup01.location}"
    resource_group_name =   "${azurerm_resource_group.resourcegroup01.name}"
    managed             =   "True"
}

resource "azurerm_network_interface" "webservers-nics01" {
    count               =   "${var.servercount}"
    name                =   "${var.servername}0${count.index + 1}-nic"
    location            =   "${azurerm_resource_group.resourcegroup01.location}"
    resource_group_name =   "${azurerm_resource_group.resourcegroup01.name}"

    ip_configuration {
        name                            =   "ipconfig01"
        subnet_id                       =   "${azurerm_subnet.vnet01-subnet01.id}"
        private_ip_address_allocation   =   "dynamic"
    }
}


resource "azurerm_virtual_machine" "webservers01" {
    count                   =   "${var.servercount}"
    name                    =   "${var.servername}0${count.index + 1}"
    location                =   "${azurerm_resource_group.resourcegroup01.location}"
    resource_group_name     =   "${azurerm_resource_group.resourcegroup01.name}"
    network_interface_ids   =   ["${element(azurerm_network_interface.webservers-nics01.*.id, count.index)}"]
    vm_size                 =   "${var.serversize}"
    availability_set_id     =   "${azurerm_availability_set.webservers-availset01.id}"

    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2016-Datacenter-smalldisk"
        version   = "latest"
    }
    storage_os_disk {
        name                =   "${var.servername}0${count.index + 1}-osdisk"
        managed_disk_type   =   "Standard_LRS"
        caching             =   "ReadWrite"
        create_option       =   "FromImage"
    }

    os_profile {
        computer_name  = "${var.servername}0${count.index + 1}"
        admin_username = "${var.serverusername}"
        admin_password = "${var.serverpassword}"
    }

    os_profile_windows_config {
        provision_vm_agent = "True"
    }
}

resource "azurerm_virtual_machine_extension" "webservercseinitialise" {
    name                    =   "${var.servername}0${count.index + 1}-init"
    count                   =   "${var.servercount}"
    location                =   "${azurerm_resource_group.resourcegroup01.location}"
    resource_group_name     =   "${azurerm_resource_group.resourcegroup01.name}"
    virtual_machine_name    =   "${azurerm_virtual_machine.webservers01.*.name}"
    virtual_machine_name    =   "${element(azurerm_virtual_machine.webservers01.*.name, count.index)}"
    publisher               =   "Microsoft.Compute"
    type                    =   "CustomScriptExtension"
    type_handler_version    =   "1.8"

    settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -command \"install-windowsfeature web-server; return 0\""
    }
SETTINGS
}