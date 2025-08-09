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

