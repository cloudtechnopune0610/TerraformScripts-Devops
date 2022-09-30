variable "resource_group_name" {
    type = string
       }

variable "resource_group_location" {
    type = string
    
}
variable "virtual_network_name" {
    type = string
}

variable "address_space" {
    #type = list
    
}

variable "address_prefixes" {
    #type = list
    
}

 variable "subscription_id" {
    type = string
    
}

variable "client_id" {
    type = string
    
}

variable "client_secret" {
    type = string
    
}

variable "tenant_id" {
    type = string
    
}



variable "subnet_name" {
    #type = list
    
}

variable "public_ip" {
    #type = list
    
}

variable "network_interface" {
    #type = list
}

variable "config_name" {
    #type = list
}

variable "network_security_group" {
    #type = list
}

variable "avset_name" {
    #type = list
}

variable "vm_name" {
    #type = string
       }
       
variable "osdisk_name" {
    #type = string
       }

variable "managed_disk" {
    #type = string
       }

 variable "computer_name" {
    #type = string
       }

 variable "resource_prefix" {
    #type = string
       }      
