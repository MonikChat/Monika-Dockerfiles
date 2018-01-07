#!/bin/sh

# The reason we're doing the package install here is to keep everything in one layer for easier downloads
# It's relatively more convinient this way
apt update && \
apt install -y \
    apt-utils \
    zlib1g-dev \
    sudo \
    build-essential \
    curl \
    wget \
    gcc \
    ffmpeg \
    clang \
    git \
    tar \
    cmake \
    openssh-server \
    gettext  \

curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash - && \
sudo apt -y install nodejs

# npm install yo?
npm i -g pm2

# manually install Python 3.6
cd /usr/src && \
   wget https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tgz && \
   tar xzf Python-3.6.4.tgz && \
   cd Python-3.6.4 && \
   ./configure --enable-optimizations && \
   make altinstall && \
   rm -rf /usr/src/Python-3.6.4.tgz && \
/usr/bin/python3.6 -V

# Create user
mkdir /var/run/sshd && \
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
useradd -u 1000 -G users,sudo -d /home/user --shell /bin/bash -m user && \
usermod -p "*" user 

#clone repo, expose Clara as app, then trim contents
cd /opt && \
git clone https://github.com/MonikaDesu/monika && \
mkdir /opt/app && \
mv /opt/monika/src/Clara/* /opt/app && \
mv /opt/monika/package.json /opt/app && \
rm -rf /opt/Clara && \
cd /opt/app && \
npm i --save --no-prune

# perm root awau
chmod g+rw /opt
chgrp root /opt

# allow to run on openshift
chown -R user:root /opt/app
chmod -R g+rw /opt/app
chmod -R g+rw /home/user
find /home/user -type d -exec chmod g+x {} +
