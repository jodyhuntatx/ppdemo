# Puppet-Conjur Integration Demo
This is a demo  integration of Puppet and Conjur using Conjur modulel from puppet forge. The demo includes sample webapp nodes that use hardcode secrets vs secrets retrieved from Conjur. 
The demo also shows how Puppet module use HF token to automatically bootstrap machine identity for puppet node. 

## Demo Requirements
1. Linux host with Docker daemon and Docker Compose installed
2. Conjur Enteprise 5.x image - Load the image to docker using `docker load -i conjur-appliance-5.x.x.x.tar`.  
Edit `docker-compose.yml` if using a different version. 
3. Puppet Standalone image. - This can be download from https://puppet.com/download-puppet-enterprise  
The script was tested with version 6.

## Setting Up The Demo Environment
The build process may take 10-15 minutes and require Internet connection.

```
./0-build-all.sh
```

After finish, execute `docker images` to check the new images. There should be three new images in local docker repo. 


## Starting The Demo
To start the demo, execute `./1-start-demo.sh`
This will bring up following services
- puppet - Puppet Enterprise server
- conjur - Conjur Server
- conjurcli - Conjur cli to load policy and secret
- dev-webapp
- pro-webapp

Conjur service is exposed on port 443 and puppet service is exposed on port 1443.  
Web console credentail is admin/Cyberark1.
OS credential is root/Cyberark1.

## Running The Demo
Conjur policy for the demo is already loaded. In this demo, there are sample manifest for two nodes. The dev-webapp show a sample manifest using hardccode credential. The prod-webapp demoonsntate how Conjur can be used to establish machiine identtiy and fetch secret.
1) Review manifest file in `puppet/manifests/site.pp`. 
2) SSH to dev-webappp then run `puppet agent -t` to apply configuration (or run 3-puppet-run-dev.sh). The puppet simply dumps the hardcoded password into a file at /etc/mysecretkey.
3) Login to Conjur UI and review the puppetdemo policy. Create new hostfactory under puppetdemo/webapp layer (via UI or 2-gen-hf-token.sh). Copy this host factory and paste it to hostfactory parameter in `puppet/manifests/site.pp` file.
4) SSH to prod-webapp. Run 'ls /etc/conjur*' to show absence of Conjur identity files. Run `puppet agent -t` to apply configuration. Run 'ls /etc/conjur*' again to show identity files.
5) In Conjur UI:
  - Review new host that is created
  - Show secret in Conjur is same as secret retrieved by Puppet agent
  - Show audit activities.
  - Change secret and re-run puppet agent to show it retrieves the rotated value.

The dev-webappa and prod-webapp can be restart wiht `./restart-demowebapp.sh`. This will remove and restart containers as well as purge those from Puppet Enterprise.

To restart all services, reexecute `./1-start-demo.sh` again.

To stop and remove all containers, `5-down-all.sh`

# Acknowledgments:
This an update of Apichet Chayabejara's ppdemo built for Puppet Enterprise 2016.
