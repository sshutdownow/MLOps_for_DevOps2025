#!/bin/sh

# Stop all the containers
docker stop $(docker ps -qa)

# Remove all the containers
docker rm $(docker ps -qa)

# Remove all images
#docker rmi -f $(docker images -qa)

# Remove all volumes
#docker volume rm $(docker volume ls -q)

# Remove all networks
docker network rm $(docker network ls -q)
