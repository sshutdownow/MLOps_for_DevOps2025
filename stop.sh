#!/bin/sh

export CLEARML_AGENT_ACCESS_KEY=6WSKVKHI0X050S9E8GK8NZFFM03PC6
export CLEARML_AGENT_SECRET_KEY=5Hp8AQevvQ2fgeVrq7hJRER0JHoaLDl3s7zWWIeO85V1cl3LGZmIbtIGotKqxArvc4Q
#
export CLEARML_API_ACCESS_KEY="46UPAS6BW5NAR024XDX7K4EZO6WDNI"
export CLEARML_API_SECRET_KEY="hmYx0cJFhkr6cXor4KjBG_E2iupeFDWIeQ1CWI0gI5X0rby1oExJrDJLAoV80vO_lKI"
#
export CLEARML_HOST_IP=192.168.28.115
export CLEARML_WEB_HOST="http://192.168.28.115:8080"
export CLEARML_API_HOST="http://192.168.28.115:8008"
export CLEARML_FILES_HOST="http://192.168.28.115:8081"

[ -f /opt/clearml/compose-triton-intel.yaml ] && docker-compose --env-file /opt/clearml/.env.triton -f /opt/clearml/compose-triton-intel.yaml down
[ -f /opt/clearml/docker-compose.yml ] && docker-compose -f /opt/clearml/docker-compose.yml down
