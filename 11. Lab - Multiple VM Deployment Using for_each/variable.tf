variable "rgname" {
  type = string
}

variable "rglocation" {
  type = string
}

variable "vnetname" {
  type = string
}

variable "subnetname1" {
  type = string
}

variable "addresprefix1" {
  type = list(any)
}

variable "vm_names" {
  type = set(string)
}

variable "addressspace1" {
  type = list(any)
}

variable "machinetype" {
  type = string
}

variable "userid" {
  type = string
}

variable "passcode" {
  type = string
}

variable "mspublisher" {
  type = string
}

variable "msoffer" {
  type = string
}

variable "mssku" {
  type = string
}
variable "msversion" {
  type = string
}

variable "security_rule" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
default = [
  {
    name                       = "rule1"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "rule2"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]
}

