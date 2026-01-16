#!/bin/bash
#
export CLEARML_AGENT_ACCESS_KEY=6WSKVKHI0X050S9E8GK8NZFFM03PC6
export CLEARML_AGENT_SECRET_KEY=5Hp8AQevvQ2fgeVrq7hJRER0JHoaLDl3s7zWWIeO85V1cl3LGZmIbtIGotKqxArvc4Q
#
export CLEARML_API_ACCESS_KEY="46UPAS6BW5NAR024XDX7K4EZO6WDNI"
export CLEARML_API_SECRET_KEY="hmYx0cJFhkr6cXor4KjBG_E2iupeFDWIeQ1CWI0gI5X0rby1oExJrDJLAoV80vO_lKI"
export CLEARML_HOST_IP=192.168.28.115

#export CLEARML_AGENT_GIT_USER=git_username_here
#export CLEARML_AGENT_GIT_PASS=git_password_here


docker-compose --env-file /opt/clearml/.env.common \
    -f /opt/clearml/docker-compose.yml up -d

docker-compose --env-file /opt/clearml/.env.triton \
    -f /opt/clearml/compose-triton-intel.yaml up -d
