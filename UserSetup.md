# Setting up Dev Envrionment

This outlines how to setup access for the dev environment. 

1. Install the Ubuntu Subsystem for linux. Instructions to do this here:
https://learn.microsoft.com/en-us/windows/wsl/install

2. In the Ubuntu subsystem, create the SSH custom key pair:
```
$> ssh-keygen -t rsa -b 4096 -C "<name>"
```

3. Copy the keypair to the server
```
$> ssh -i id_rsa <username>@<server_address>
```

- The username is in the format firstname.lastname
- The server address can be foudn from the design document
- Name is in the standard format

