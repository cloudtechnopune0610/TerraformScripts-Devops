# Multiple VM Deployment
# One time services creation 
rgname        = "DC900"
rglocation    = "east us"
vnetname      = "fe-vnet"
subnetname1   = "websubnet"
addressspace1 = [ "10.0.0.0/16" ]
addresprefix1 = ["10.0.1.0/24"]

# Values need to change as per requirement 
vm_names      = ["vm1"]
machinetype   = "Standard_B1s"
userid        = "admin100"
passcode      = "Passw0rd@12345"
mspublisher   = "MicrosoftWindowsServer"
msoffer       = "WindowsServer"
mssku         = "2016-Datacenter"
msversion     = "latest"
