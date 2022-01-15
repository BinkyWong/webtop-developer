FROM ghcr.io/linuxserver/webtop:ubuntu-mate

WORKDIR /tmp/

# Setup Google Chrome & Visual Studio Code sources

RUN apt-get update &&\
    apt-add-repository ppa:remmina-ppa-team/remmina-next &&\
    apt-get upgrade -y &&\
    apt-get install wget -y

# Install signing keys for Chrome and VSCode

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - &&\
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg &&\
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ &&\
    sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' &&\
    rm -f packages.microsoft.gpg 

COPY google-chrome.list /etc/apt/sources.list.d/

# Install Google Chrome, Firefox and Vistual Studio Code plus any other required applications

RUN apt-get update &&\
    apt-get install google-chrome-stable code vim git fonts-liberation xdg-utils htop firefox ansible ansible-lint iputils* sshpass sshfs remmina remmina-plugin-rdp remmina-plugin-secret -y 

# Cleanup

RUN apt-get autoclean && \
  rm -rf \
  /var/lib/apt/lists/* \
  /var/tmp/* \
  /tmp/*