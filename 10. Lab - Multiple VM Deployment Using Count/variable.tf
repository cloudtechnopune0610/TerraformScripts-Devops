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
  type = list(any)
}

variable "vmtype" {
  type = string
}

variable "machinecount" {
  type = number 
}
