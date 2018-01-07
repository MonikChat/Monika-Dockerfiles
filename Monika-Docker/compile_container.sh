#!/bin/sh

# The reason we're doing the package install here is to keep everything in one layer for easier downloads
# It's relatively more convinient this way

apt install -y \
    sudo \
    build-essential \
    curl \
    wget \
    gcc \
    ffmpeg \
    clang \
    git \
    tar \
    which \
    cmake \
    openssh-server \
    openssl-devel \
    nss_wrapper \
    gettext  \

curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash - && \
sudo apt -y install nodejs

# npm install yo?
npm i -g pm2

# manually install Python 3.6
cd /usr/src && \
   wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tgz && \
   tar xzf Python-3.6.3.tgz && \
   cd Python-3.6.3 && \
   ./configure --enable-optimizations && \
   make altinstall && \
   rm -rf /usr/src/Python-3.6.3.tgz && \
/usr/bin/python3 -V

# Create user
mkdir /var/run/sshd && \
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
useradd -u 1000 -G users,sudo -d /home/user --shell /bin/bash -m user && \
usermod -p "*" user 

#clone repo, expose Clara as app, then trim contents
git clone https://github.com/MonikaDesu/monika --bare --depth=10 /opt/monika && \
mkdir /opt/app && \
rm -rf /opt/Clara

# perm root awau
chmod g+rw /opt
chgrp root /opt

# allow to run on openshift
chown -R user:root /opt/app
chmod -R g+rw /opt/app
chmod -R g+rw /home/user
find /home/user -type d -exec chmod g+x {} +
