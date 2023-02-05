#!/bin/bash

# update machine
sudo apt-update -y
sudo apt-upgrade -y

# install docker dependencies
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release


# add docker gpg key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# add docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 sudo apt-get -y update


# install docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# start docker service
sudo systemctl enable docker.service

# add ubuntu to docker group
sudo usermod -aG docker ubuntu