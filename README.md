# Food Security Dashboard
This repository stores configuration items & documentation for the Food Security dashboard.


### AWS EC2 Details
EC2 t3.medium with 80gb drive

To connect:

1. Create SSH custom key pair
`ssh-keygen -t rsa -b 4096 -C "alex.nevin"`
`chmod 600 ~/.ssh/*`
`chmod 700 ~/.ssh`

2. Copy permissions to the SSH server
`ssh -i id_rsa <username>@<server_address>`

### Grafana Details
Grafana setup details are as follows:
```
sudo apt-get install -y apt-transport-https software-properties-common wget
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install grafana
sudo systemctl status grafana-server
sudo systemctl daemon-reload
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl status grafana-server
sudo systemctl edit grafana-server.service
```

Alex has the access details.

Need to change the running port, SSL, domain name, create users.
