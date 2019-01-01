sudo apt update
sudo apt -y upgrade
sudo apt install -y python-pip htop vim software-properties-common apt-transport-https ca-certificates curl software-properties-common build-essential python-all

#Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

#Ansible
sudo apt-add-repository --yes --update ppa:ansible/ansible

sudo apt-get update
sudo apt install docker-ce ansible

sudo usermod -aG docker ubuntu
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
