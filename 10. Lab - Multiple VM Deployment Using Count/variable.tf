variable "prefix" {
  type = string
}


variable "location" {
  type = string
}

variable "addressspace1" {
  type = list(any) 
}

variable "subnetname" {
  type = string
}
variable "address1" {
  type = string
}

variable "vmtype" {
  type = string
}

variable "machinecount" {
  type = number 
}

variable "hostname" {
  type = string
}
