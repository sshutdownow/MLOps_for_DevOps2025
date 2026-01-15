#!/bin/sh
# https://clear.ml/docs/latest/docs/deploying_clearml/clearml_server_linux_mac/

#sudo rm -R /opt/clearml/
#sudo rm -R /opt/allegro/

sudo mkdir -pv /opt/allegro/data/elastic7plus
sudo chown 1000:1000 /opt/allegro/data/elastic7plus
sudo mkdir -pv /opt/allegro/data/mongo_4/configdb
sudo mkdir -pv /opt/allegro/data/mongo_4/db
sudo mkdir -pv /opt/allegro/data/redis
sudo mkdir -pv /opt/allegro/data/fileserver
sudo mkdir -pv /opt/allegro/data/fileserver/tmp
sudo mkdir -pv /opt/allegro/logs/apiserver
sudo mkdir -pv /opt/allegro/documentation
sudo mkdir -pv /opt/allegro/logs/fileserver
sudo mkdir -pv /opt/allegro/logs/fileserver-proxy
sudo mkdir -pv /opt/allegro/data/fluentd/buffer
sudo mkdir -pv /opt/allegro/config/webserver_external_files
sudo mkdir -pv /opt/allegro/config/onprem_poc

#sudo curl https://raw.githubusercontent.com/clearml/clearml-server/master/docker/docker-compose.yml -o /opt/clearml/docker-compose.yml

#export CLEARML_AGENT_ACCESS_KEY=generate_access_key_here
#export CLEARML_AGENT_SECRET_KEY=generate_secret_key_here
#export CLEARML_HOST_IP=server_host_ip_here
#export CLEARML_AGENT_GIT_USER=git_username_here
#export CLEARML_AGENT_GIT_PASS=git_password_here
