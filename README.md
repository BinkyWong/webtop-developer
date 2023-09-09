# Virtual Desktop Webtop Developer DevOps Fully Loaded Edition

Run Visual Studio Code and Google Chrome in Docker in your browser!

This is based on the excellent work from:

https://docs.linuxserver.io/images/docker-webtop

This virtual desktop contains:

* Google Chrome
* Firefox
* Visual Studio Code
* Ansible
* DotNet 7 
* Powershell
* Vagrant
* KVM/Qemu nested virtualization
* virt-manager to manage VMs

However you can easily add more applications by editing the Dockerfile. 

# Build

docker built -t webtop .

# Basic Usage

docker run --privileged -it -p 3000:3000 --shm-size=4gb webtop

# Advanced - Using Docker Compose 

docker-compose up -d --force-recreate

# Open in your browser

http://localhost:3000

# Persistent data

All data is persisted in the /config folder which is effectively the home directory for that container.

You can persist data by mounting a folder to /config so everything you do in between sessions is persisted using the following example:

docker run --privileged --shm-size=4gb -it -p 80:3000 -v ${PWD}/config:/config webtop
