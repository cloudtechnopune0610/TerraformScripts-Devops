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

