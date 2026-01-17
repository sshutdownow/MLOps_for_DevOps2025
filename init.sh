#!/bin/bash
# https://clear.ml/docs/latest/docs/deploying_clearml/clearml_server_linux_mac/
# oss
#sudo rm -R /opt/clearml/
sudo mkdir -p /opt/clearml/data/elastic_7
sudo mkdir -p /opt/clearml/data/mongo_4/db
sudo mkdir -p /opt/clearml/data/mongo_4/configdb
sudo mkdir -p /opt/clearml/data/redis
sudo mkdir -p /opt/clearml/logs
sudo mkdir -p /opt/clearml/config
sudo mkdir -p /opt/clearml/data/fileserver

cp -f datasource.yml prometheus.yml /opt/clearml/
cp -f apiserver.conf /opt/clearml/config/

sudo chown -R 1000:1000 /opt/clearml

[ ! -f /opt/clearml/docker-compose.yml ] && sudo curl https://raw.githubusercontent.com/clearml/clearml-server/master/docker/docker-compose.yml -o /opt/clearml/docker-compose.yml
[ ! -f /opt/clearml/compose-triton-intel.yaml ] && sudo curl https://raw.githubusercontent.com/clearml/clearml-serving/master/docker/compose-triton-intel.yaml -o /opt/clearml/compose-triton-intel.yaml

export CLEARML_AGENT_ACCESS_KEY=6WSKVKHI0X050S9E8GK8NZFFM03PC6
export CLEARML_AGENT_SECRET_KEY=5Hp8AQevvQ2fgeVrq7hJRER0JHoaLDl3s7zWWIeO85V1cl3LGZmIbtIGotKqxArvc4Q
#
#CLEARML_API_ACCESS_KEY="${CLEARML_AGENT_ACCESS_KEY}"
#CLEARML_API_SECRET_KEY="${CLEARML_AGENT_SECRET_KEY}"
export CLEARML_HOST_IP=192.168.28.115

#export CLEARML_AGENT_GIT_USER=git_username_here
#export CLEARML_AGENT_GIT_PASS=git_password_here


docker-compose --env-file /opt/clearml/.env.common \
    -f /opt/clearml/docker-compose.yml up -d

python3 -m venv venv || exit 1
source venv/bin/activate || exit 1
pip install --upgrade pip || exit 1
pip install -U clearml-serving || exit 1

CLEARML_SERVING_TASK_ID=$(clearml-serving create --name "Amazon Reviews" | grep -oP 'id=\K[0-9a-f]+')
cat /opt/clearml/.env.common >> /opt/clearml/.env.triton
echo "CLEARML_SERVING_TASK_ID=${CLEARML_SERVING_TASK_ID}" >> /opt/clearml/.env.triton

docker-compose --env-file /opt/clearml/.env.triton \
    -f /opt/clearml/compose-triton-intel.yaml up -d

clearml-serving --id "${CLEARML_SERVING_TASK_ID}" model add --engine sklearn --endpoint "sentiment_analyze" --published --project "Amazon reviews" --name "TF-IDF Vectorize BernoulliNB" --preprocess "preprocessing.py"
clearml-serving --id "${CLEARML_SERVING_TASK_ID}" model auto-update --engine sklearn --endpoint "sentiment_analyze" --published --project "Amazon reviews" --name "TF-IDF Vectorize BernoulliNB" --max-versions 5 --preprocess "preprocessing.py"
clearml-serving --id "${CLEARML_SERVING_TASK_ID}" model list

pushd streamlit_app
docker-compose --env-file /opt/clearml/.env.common \
    -f docker-compose-app.yml up --build -d
popd
