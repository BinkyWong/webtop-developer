# Virtual Desktop Webtop Developer Edition

Run Visual Studio Code and Google Chrome in Docker in your browser!

This is based on the excellent work from:

https://docs.linuxserver.io/images/docker-webtop

This virtual desktop contains:

* Google Chrome
* Firefox
* Visual Studio Code
* Ansible

However you can easily add more applications by editing the Dockerfile. 

# Build

docker built -t webtop .

# Run

docker run --shm-size="2gb" --privileged -it -p 3000:3000 webtop

# Open in your browser

http://localhost:3000


