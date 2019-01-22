variable "location" {
    type    =   "string"
    default =   "West Europe"
}

variable "resourcegroupname" {
    type    =   "string"
    default =   "webfarmrg"
}

variable "vnetname" {
    type    =   "string"
    default =   "webfarmvnet01"
}

variable "vnetaddressspace" {
    type    =   "list"
    default =   ["10.0.0.0/16"]
}

variable "subnetname" {
    type    =   "string"
    default =   "webfarmsubnet01"
}

variable "subnetprefix" {
    type    =   "string"
    default =   "10.0.1.0/24"
}

variable "servername" {
    type    =   "string"
    default =   "webserver"
}

variable "serversize" {
    type    =   "string"
    default =   "Standard_A2_v2"
}

variable "servercount" {
    type    =   "string"
    default =   2
}

variable "serverusername" {
    type    =   "string"
    default =   "User123"
}

variable "serverpassword" {
    type    =   "string"
    default =   "****"
}

variable "lbname" {
    type    =   "string"
    default =   "webloadbalancer01"
}