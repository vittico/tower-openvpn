docker rm -f $(docker ps -aq)
docker system prune -a
cd
sudo rm -rf /home/ubuntu/awx
sudo rm -rf /home/ubuntu/awx-docker
