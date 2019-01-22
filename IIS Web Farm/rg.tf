resource "azurerm_resource_group" "resourcegroup01" {
    name        =   "${var.resourcegroupname}"
    location    =   "${var.location}"
}