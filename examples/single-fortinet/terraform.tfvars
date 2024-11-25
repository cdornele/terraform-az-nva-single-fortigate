#--------------------------------------------*--------------------------------------------
# Example - Single Fortinet
#--------------------------------------------*--------------------------------------------

settings = {
    global_settings = {
        name          = "fortinet"
        prefixes      = ["az", "eus"]
        suffixes      = ["d", "01"]
    }
    location = "eastus"
    network = {
        public_ip_prefix = ["untrust"]
        fortinet_prefix = "fgt"
        untrust_ip = "192.168.0.5"
        untrust_gateway = "192.168.0.1"
        untrust_netmask = "255.255.255.240"
        trust_ip = "192.168.0.21"
        trust_netmask = "255.255.255.240"
    }
    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true
    disable_password_authentication = false
    fortinet_accept_agreement = false
    fortinet_vm_name = "fgtnode01"
    fortinet_vm_size = "Standard_F4"
    fortinet_vm_username = "fgtlocaladmin"
    fortinet_vm_password = "P@ssw0rd4890"
    fortinet_publisher_id = "fortinet"
    fortinet_offer_id = "fortinet_fortigate-vm_v5"
    fortinet_license_type = "payg"
    fortinet_sku_id= {
        byol = "fortinet_fg-vm"
        payg = "fortinet_fg-vm_payg_2023"
    }
    fortinet_version = "7.6.0"
    fortinet_license_file = "license.txt"
    fortinet_license_format = "token"
    tags = {
        environment = "dev"
        customer = "test"
        owner = "IT"
    }
}