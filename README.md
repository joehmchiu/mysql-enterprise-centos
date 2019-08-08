# mysql-enterprise-centos
There are two playbooks in this repository for the automation infrastructure. 
1. mysql-centos-vm: create a Linux Centos VM in the subnet and mount three disks for mysql database.
2. mysql-enterprise: build a MySQL Enterprise 8.x database, create a root user, setup the configuration, build the firewalls, install the requested packages, run unit tests and finalize the installation.

# System
- Azure Cloud
- Linux Centos 7.5
- MySQL Enterprise 8.x

# Tool
- Ansible playbook

# Automation Infrastructure
- Linux Centos 
- SSH connections
- /dev/sdc
- /dev/sdd
- /dev/sde
- MySQL Database
- Database Access
- System configurations
- Permission configurations
- Unit test
- Security configuration
