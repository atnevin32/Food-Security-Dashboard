#!/bin/bash
#

#sudo apt-get install mysql-server -y

apt-get install -y apt-transport-https software-properties-common wget
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com beta main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
apt-get update
apt-get install grafana-server -y


apt-get install python3-venv
pip install mysql-connector-python


mysql -u 'root' -e "CREATE USER 'data_feed'@'localhost' IDENTIFIED BY 'D@T@F33d';"
mysql -u 'root' -e "GRANT ALL PRIVILEGES ON *.* TO 'data_feed'@'localhost' WITH GRANT OPTION;"
mysql -u 'root' -e "FLUSH PRIVILEGES;"

python3 Configure_Database.py
