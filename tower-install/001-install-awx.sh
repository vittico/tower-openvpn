pip install docker
pip install docker-compose
pip install --upgrade ansible-tower-cli
git clone https://github.com/ansible/awx.git
cd awx
git fetch --all --tags --prune
git checkout tags/2.1.2
git clone https://github.com/ansible/awx-logos

cd 

mkdir -p /home/ubuntu/awx-docker/postgres
mkdir -p /home/ubuntu/awx-docker/awx
mkdir -p /home/ubuntu/awx-docker/awx/projects

cp inventory awx/installer/inventory
cd awx/installer
ansible-playbook -i inventory install.yml

