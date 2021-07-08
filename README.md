# Deploy Azure VM with Enterprise MySQL by IaC 

## mysql-enterprise-centos
There are two playbooks in this repository for the automation infrastructure as code. 
1. mysql-centos-vm: 
  - create a Linux Centos VM in the customized vnet and subnet
  - create two extra storage disks for database data and logs
  - create ssh connection
  - configure firewalls
  - mount the created disks for mysql database
3. mysql-enterprise: 
  - install MySQL Enterprise 8.x database
  - create root and user accounts
  - setup the MySQL configurations by Jinja2 template
  - initiralize and preload for the installation
  - requested packages installation 
  - run unit tests and finalize the installation
  - report the installation process

## Cloud and System
- Azure Cloud
- Linux Centos 7.5
- MySQL Enterprise 8.x

## Tools
- Ansible playbook
- and / or CI / CD tools

## Automation Infrastructure
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
