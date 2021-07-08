
# create VM for Enterprise MySQL database
cd  mysql-centos-vm
sudo ansible-playbook playbook.yml

# run playbook to install MySQL enterprise database
cd mysql-enterprise
sudo ansible-playbook -i mysql-hosts playbook.yml
