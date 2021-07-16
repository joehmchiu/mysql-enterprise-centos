variable "resourcename" {
  default = var.rg
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
    # you can run sh env to export the variables to enviroment instead
    subscription_id = "xxxxxxxx-999a-4dc0-9397-f47f358d9b35"
    client_id       = "xxxxxxxx-fbd6-4e54-9ffd-b304e6cc12b7"
    client_secret   = var.skey
    tenant_id       = "xxxxxxxx-e8ab-44ed-a16d-b579fe2d7cd8"
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "rg" {
    name     = var.rg
    location = "eastus"

    tags {
        environment = var.tag
    }
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "vnet"
    address_space       = [var.vnet_cidr]
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"

    tags {
        environment = var.tag
    }
}

# Create subnet
resource "azurerm_subnet" "subnet" {
    name                 = "subnet"
    resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
    virtual_network_name = "${azurerm_virtual_network.myterraformnetwork.name}"
    address_prefix       = var.subnet_cidr
}

# Create public IPs
resource "azurerm_public_ip" "publicIP" {
    name                         = "pub_ip"
    location                     = var.location
    resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
    public_ip_address_allocation = "static"

    tags {
        environment = var.tag
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
    name                = "nsg"
    location            = var.location
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "MySQL"
        priority                   = 1011
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3306"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags {
        environment = var.tag
    }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
    name                      = "nic"
    location                  = var.location
    resource_group_name       = "${azurerm_resource_group.myterraformgroup.name}"
    network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"

    ip_configuration {
        name                          = "privateIP"
        subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
        private_ip_address_allocation = "static"
        public_ip_address_id          = "${azurerm_public_ip.myterraformpublicip.id}"
    }

    tags {
        environment = var.tag
    }
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.myterraformgroup.name}"
    }

    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "storageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = "${azurerm_resource_group.myterraformgroup.name}"
    location                    = var.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags {
        environment = var.tag
    }
}

# Create virtual machine
resource "azurerm_virtual_machine" "vm" {
    name                  = "vm"
    location              = var.location
    resource_group_name   = "${azurerm_resource_group.myterraformgroup.name}"
    network_interface_ids = ["${azurerm_network_interface.myterraformnic.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "OsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "OpenLogic"
        offer     = "CentOS"
        sku       = "7.5"
        version   = "latest"
    }

    os_profile {
        computer_name  = "mysql01"
        admin_username = "azureuser"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = var.sshdata
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

    tags {
        environment = var.tag
    }
}

