#!/bin/bash -xe
sudo apt-get update -y
sudo apt-get install -y docker-compose
git clone https://github.com/nayeem-17/express-api-template.git
cd express-api-template
sudo docker-compose up -d