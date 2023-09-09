FROM ghcr.io/linuxserver/webtop:ubuntu-mate

WORKDIR /tmp/

# Setup Google Chrome & Visual Studio Code sources

RUN apt-get update &&\
    apt-add-repository ppa:remmina-ppa-team/remmina-next &&\
    apt-get upgrade -y &&\
    apt-get install wget apt-transport-https software-properties-common -y

# Setup Vagrant GPG keys

RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg &&\
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

# Install signing keys for Chrome and VSCode

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - &&\
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg &&\
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ &&\
    sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' &&\
    rm -f packages.microsoft.gpg 

COPY google-chrome.list /etc/apt/sources.list.d/

# Install Google Chrome, Firefox and Vistual Studio Code plus any other required applications

RUN apt-get update &&\
    apt-get install google-chrome-stable code vim git fonts-liberation xdg-utils htop firefox ansible ansible-lint iputils* sshpass sshfs remmina remmina-plugin-rdp remmina-plugin-secret neofetch virt-manager libvirt-dev build-essential rsync vagrant -y 

# Install DBeaver and MS repo using Ansible :p 

RUN ansible -m apt -a deb=https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb localhost &&\
    ansible -m apt -a deb="https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" localhost

RUN apt-get update && apt install powershell -y

# Install .NET 7 stuff

RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh

RUN chmod +x ./dotnet-install.sh

RUN ./dotnet-install.sh --channel 7.0

#RUN chmod 755 -R /root/.dotnet && chmod 755 /root

RUN chmod 755 -R /config/.dotnet

#RUN echo "export DOTNET_ROOT=/root/.dotnet" >> /etc/skel/.bashrc

RUN echo "export DOTNET_ROOT=/config/.dotnet" >> /etc/skel/.bashrc

#RUN echo "export PATH=$PATH:/root/.dotnet:/root/.dotnet/tools" >> /etc/skel/.bashrc

RUN echo "export PATH=$PATH:/config/.dotnet:/root/.dotnet/tools" >> /etc/skel/.bashrc

# Cleanup

RUN apt-get install virt-manager -y

# Build Vagrant Plugin

RUN vagrant plugin install vagrant-libvirt

RUN apt-get autoclean && \
  rm -rf \
  /var/lib/apt/lists/* \
  /var/tmp/* \
  /tmp/*
